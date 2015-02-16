require 'duse/cli/confirm_account'
require 'duse/cli/resend_confirmation'

module Duse
  module CLI
    class Account < ApiCommand
      subcommand :confirm, ConfirmAccount
      subcommand :resend_confirmation, ResendConfirmation

      description 'Manage your account'

      def run(*arguments)
        say help
      end
    end
  end
end

