require 'duse/cli'
require 'duse/cli/password_helper'

module Duse
  module CLI
    class ChangePassword < ApiCommand
      include PasswordHelper

      description 'change your password'

      on('-t', '--token [TOKEN]', 'The token to use for password reset')

      def run
        if self.token
          Duse.session.patch('/users/password', {
            token: self.token,
            password: ask_for_password
          })
        else
          user = Duse::User.find('me')
          Duse::User.update(user.id, {
            password: ask_for_password,
            current_password: ask_for_current_password
          })
        end
        success 'Successfully updated your password!'
      end
    end
  end
end
