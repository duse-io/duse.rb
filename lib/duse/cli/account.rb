require 'duse/cli/confirm_account'

module Duse
  module CLI
    class Account < ApiCommand
      subcommand :confirm, ConfirmAccount

      description 'Manage your account'

      def run(*arguments)
        say help
      end
    end
  end
end

