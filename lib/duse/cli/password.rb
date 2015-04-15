require 'duse/cli/change_password.rb'
require 'duse/cli/reset_password.rb'

module Duse
  module CLI
    class Password < ApiCommand
      subcommand :change, ChangePassword
      subcommand :reset, ResetPassword

      description 'Manage your password'

      def run
        say help
      end
    end
  end
end

