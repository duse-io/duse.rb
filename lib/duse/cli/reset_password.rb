require 'duse/cli'

module Duse
  module CLI
    class ResetPassword < ApiCommand
      description 'request a reset of your password'

      skip :authenticate

      on('-e', '--email [EMAIL]', 'Your email')

      def run
        self.email ||= terminal.ask('Your email: ')
        response = Duse.session.post('/users/forgot_password', { email: self.email })
        success 'An email with instructions on how to reset your password has been sent.'
      end
    end
  end
end

