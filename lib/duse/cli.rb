require 'stringio'
require 'duse'
require 'duse/cli/cli_config'

module Duse
  module CLI
    autoload :Command,    'duse/cli/command'
    autoload :ApiCommand, 'duse/cli/api_command'
    autoload :Help,       'duse/cli/help'
    autoload :Config,     'duse/cli/config'
    autoload :Login,      'duse/cli/login'
    autoload :Register,   'duse/cli/register'
    autoload :Secret,     'duse/cli/secret'

    extend self

    def run(*args)
      args, opts    = preparse(args)
      name          = args.shift unless args.empty?
      command_class = command(name)
      loop do
        unless command_class.subcommands.key? args[0]
          break
        end
        command_class = command_class.subcommands[args.shift]
      end
      command = command_class.new(opts)
      command.parse(args)
      command.execute
    end

    def command(name)
      const_name = command_name(name)
      constant   = CLI.const_get(const_name) if const_name =~ /^[A-Z][A-Za-z]+$/ and const_defined? const_name
      if command? constant
        constant
      else
        $stderr.puts "unknown command #{name}"
        exit 1
      end
    end

    def commands
      CLI.constants.map { |n| try_const_get(n) }.select { |c| command? c }
    end

    def silent
      stderr, $stderr = $stderr, dummy_io
      stdout, $stdout = $stdout, dummy_io
      yield
    ensure
      $stderr = stderr if stderr
      $stdout = stdout if stdout
    end

    def config
      CLIConfig
    end

    private

    def try_const_get(name)
      CLI.const_get(name)
    rescue Exception
    end

    def dummy_io
      return StringIO.new unless defined? IO::NULL and IO::NULL
      File.open(IO::NULL, 'w')
    end

    def command?(constant)
      constant.is_a? Class and constant < Command and not constant.abstract?
    end

    def command_name(name)
      case name
      when nil, '-h', '-?' then 'Help'
      when '-v'            then 'Version'
      when /^--/           then command_name(name[2..-1])
      else name.split('-').map(&:capitalize).join
      end
    end

    # can't use flatten as it will flatten hashes
    def preparse(unparsed, args = [], opts = {})
      case unparsed
      when Hash  then opts.merge! unparsed
      when Array then unparsed.each { |e| preparse(e, args, opts) }
      else args << unparsed.to_s
      end
      [args, opts]
    end
  end
end
