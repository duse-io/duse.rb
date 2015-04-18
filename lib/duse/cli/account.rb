require 'duse/cli/account_confirm'
require 'duse/cli/account_resend_confirmation'
require 'duse/cli/account_info'
require 'duse/cli/account_update'
require 'duse/cli/account_password'

module Duse
  module CLI
    class Account < ApiCommand
      subcommand AccountConfirm
      subcommand AccountResendConfirmation
      subcommand AccountInfo
      subcommand AccountUpdate
      subcommand AccountPassword

      description 'Manage your account'

      def run
        say help
      end
    end
  end
end

