require 'highline'
require 'duse/cli_config'

module Duse
  module CLI
    class Command
      attr_reader :output, :input
      attr_accessor :arguments, :force_interactive

      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:command]   = [ :bold             ]
        cs[:error]     = [ :red              ]
        cs[:important] = [ :bold, :underline ]
        cs[:success]   = [ :green            ]
        cs[:info]      = [ :yellow           ]
        cs[:debug]     = [ :magenta          ]
      end

      def initialize
        self.output      = $stdout
        self.input       = $stdin
        self.arguments ||= []
      end

      def parse(args)
        parser = OptionParser.new
        arguments.concat(parser.parse(args))
      end

      def execute
        puts "executing #{self.class}"
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

      def requires_authentication?
        false
      end

      # ignore Command since its not supposed to be executed
      @@abstract ||= [Command]
      def self.abstract?
        @@abstract.include? self
      end

      def self.abstract
        @@abstract << self
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
    end
  end
end
