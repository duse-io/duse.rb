require 'duse/cli/confirm_account'
require 'duse/cli/resend_confirmation'
require 'duse/cli/info_account'
require 'duse/cli/update_account'
require 'duse/cli/password'

module Duse
  module CLI
    class Account < ApiCommand
      subcommand :confirm, ConfirmAccount
      subcommand :resend_confirmation, ResendConfirmation
      subcommand :info, InfoAccount
      subcommand :update, UpdateAccount
      subcommand :password, Password

      description 'Manage your account'

      def run
        say help
      end
    end
  end
end

