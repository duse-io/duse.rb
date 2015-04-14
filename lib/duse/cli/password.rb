require 'duse/cli/change_password.rb'

module Duse
  module CLI
    class Password < ApiCommand
      subcommand :change, ChangePassword

      description 'Manage your password'

      def run(*arguments)
        say help
      end
    end
  end
end

