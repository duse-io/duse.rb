require 'highline'
require 'duse/cli/cli_config'
require 'duse/cli/parser'

module Duse
  module CLI
    class Command
      attr_reader :output, :input
      attr_accessor :arguments, :force_interactive

      extend Parser

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:command]   = [ :bold             ]
        cs[:error]     = [ :red              ]
        cs[:important] = [ :bold, :underline ]
        cs[:success]   = [ :green            ]
        cs[:info]      = [ :yellow           ]
        cs[:debug]     = [ :magenta          ]
      end

      on('-h', '--help', 'Display help') do |c, _|
        c.say c.help
        exit
      end

      def initialize(options = {})
        self.output      = $stdout
        self.input       = $stdin
        self.arguments ||= []
        options.each do |key, value|
          public_send("#{key}=", value) if respond_to? "#{key}="
        end
        @arguments ||= []
      end

      def parse(args)
        arguments.concat(parser.parse(args))
      rescue OptionParser::ParseError => e
        error e.message
      end

      def execute
        run *arguments
      rescue Interrupt
        say "\naborted!"
      end

      def output=(io)
        @terminal = nil
        @output = io
      end

      def input=(io)
        @terminal = nil
        @input = io
      end

      def terminal
        @terminal ||= HighLine.new(input, output)
      end

      # ignore Command since its not supposed to be executed
      @@abstract ||= [Command]
      def self.abstract?
        @@abstract.include? self
      end

      def self.abstract
        @@abstract << self
      end

      def self.skip(*names)
        names.each { |n| define_method(n) {} }
      end

      def self.super_command=(command_class)
        @super_command = command_class
      end

      def self.has_super_command?
        !@super_command.nil?
      end

      def self.super_command
        @super_command
      end

      def self.subcommand(command)
        return nil if command.nil?
        return subcommands.select { |sc| sc.command_name == command }.first if command.is_a? String
        command.super_command = self
        subcommands << command
      end

      def self.subcommands
        @subcommands ||= []
      end

      def self.has_subcommands?
        !@subcommands.empty?
      end

      def config
        CLI.config
      end

      def warn(message)
        write_to($stderr) do
          say color(message, :error)
          yield if block_given?
        end
      end

      def error(message, &block)
        warn(message, &block)
        exit 1
      end

      def success(line)
        say color(line, :success) if interactive?
      end

      def write_to(io)
        io_was, self.output = output, io
        yield
      ensure
        self.output = io_was if io_was
      end

      def color(line, style)
        return line.to_s unless interactive?
        terminal.color(line || '???', Array(style).map(&:to_sym))
      end

      def interactive?(io = output)
        return io.tty? if force_interactive.nil?
        force_interactive
      end

      def say(data, format = nil, style = nil)
        terminal.say format(data, format, style)
      end

      def self.full_command
        name[/[^:]*$/].split(/(?=[A-Z])/).map(&:downcase).join(' ')
      end

      def full_command
        self.class.full_command
      end

      def self.command_name
        return full_command.sub(super_command.full_command, '').strip.sub(' ', '-') if has_super_command?
        full_command
      end

      def command_name
        self.class.command_name
      end

      def self.description(description = nil)
        @description = description if description
        @description ||= ""
      end

      def help(info = "")
        return help_subcommands unless self.class.subcommands.empty?
        parser.banner = usage
        self.class.description.sub(/./) { |c| c.upcase } + ".\n\n" + info + parser.to_s
      end

      def help_subcommands
        result = "#{self.class.description}\n\n"
        result << "Usage: duse #{command_name} COMMAND ...\n\nAvailable commands:\n\n"
        self.class.subcommands.each { |command_class| result << "\t#{color(command_class.command_name, :command).ljust(22)} #{color(command_class.description, :info)}\n" }
        result << "\nrun `#$0 help #{command_name} COMMAND` for more infos"
        result
      end

      def usage
        "Usage: " << color(usage_for(full_command, :run), :command)
      end

      def usage_for(prefix, method)
        usage = "duse #{prefix}"
        method = method(method)
        if method.respond_to? :parameters
          method.parameters.each do |type, name|
            name = name.upcase
            name = "[#{name}]"   if type == :opt
            name = "[#{name}..]" if type == :rest
            usage << " #{name}"
          end
        elsif method.arity != 0
          usage << " ..."
        end
        usage << " [OPTIONS]"
      end
    end
  end
end
