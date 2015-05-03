require 'duse/cli'

module Duse
  module CLI
    class AccountConfirm < ApiCommand
      description 'confirm your account with a token sent to your email'

      skip :authenticate

      def run(token)
        Duse::User.confirm(token)
        success 'Account successfully confirmed.'
      rescue Duse::Client::NotFound
        error 'Token is either not valid or has already been used.'
      end
    end
  end
end

