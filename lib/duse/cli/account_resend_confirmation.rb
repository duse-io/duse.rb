require 'duse/cli'

module Duse
  module CLI
    class AccountResendConfirmation < ApiCommand
      description 'resend the confirmation email for your account'

      skip :authenticate

      on('-e', '--email [EMAIL]', 'Your email')

      def run
        self.email ||= terminal.ask('Your email: ')
        Duse::User.resend_confirmation(self.email)
        success 'New confirmation process started.'
      end
    end
  end
end

