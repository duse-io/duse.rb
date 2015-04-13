require 'duse/cli/confirm_account'
require 'duse/cli/resend_confirmation'
require 'duse/cli/info_account'
require 'duse/cli/update_account'

module Duse
  module CLI
    class Account < ApiCommand
      subcommand :confirm, ConfirmAccount
      subcommand :resend_confirmation, ResendConfirmation
      subcommand :info, InfoAccount
      subcommand :update, UpdateAccount

      description 'Manage your account'

      def run(*arguments)
        say help
      end
    end
  end
end

