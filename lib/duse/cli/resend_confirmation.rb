require 'duse/cli'

module Duse
  module CLI
    class ResendConfirmation < ApiCommand
      description 'resend the confirmation email for your account'

      skip :authenticate

      on('-e', '--email [EMAIL]', 'Your email')

      def run
        self.email ||= terminal.ask('Your email: ')
        response = Duse.session.post('/users/confirm', { email: self.email })
        success 'New confirmation process started.'
      end
    end
  end
end

