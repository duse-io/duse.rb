require 'duse/cli'

module Duse
  module CLI
    class ConfirmAccount < ApiCommand
      description 'confirm your account'

      skip :authenticate

      on('-t', '--token [TOKEN]', 'The token to use for confirming')

      def run
        self.token ||= terminal.ask("A confirmation email has been sent. A confirmation token was mentioned in it, please provide that token below.\n\ntoken: ")
        Duse.uri = config.uri
        response = Duse.session.patch('/users/confirm', { token: self.token })
        success 'Account successfully confirmed.'
      rescue Duse::Client::NotFound
        error 'Token is either not valid or has already been used.'
      end
    end
  end
end

