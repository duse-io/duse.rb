require 'duse/cli'

module Duse
  module CLI
    class Help < Command
      description "Displays help messages, such as this one"

      def run(*args)
        unless args.empty?
          say CLI.command(args).new.help
        else
          say "Usage: duse COMMAND ...\n\nAvailable commands:\n\n"
          commands.each { |c| say "\t#{color(c.command_name, :command).ljust(22)} #{color(c.description, :info)}" }
          say "\nrun `#$0 help COMMAND` for more infos"
        end
      end

      def commands
        CLI.commands.sort_by { |c| c.command_name }
      end
    end
  end
end
