require 'duse/cli/account_password_change.rb'
require 'duse/cli/account_password_reset.rb'

module Duse
  module CLI
    class AccountPassword < ApiCommand
      subcommand AccountPasswordChange
      subcommand AccountPasswordReset

      description 'Manage your password'

      def run
        say help
      end
    end
  end
end

