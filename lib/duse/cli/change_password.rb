require 'duse/cli'
require 'duse/cli/password_helper'

module Duse
  module CLI
    class ChangePassword < ApiCommand
      include PasswordHelper

      description 'change your password'

      def run
        user = Duse::User.find('me')
        Duse::User.update(user.id, {
          password: ask_for_password,
          current_password: ask_for_current_password
        })
        success 'Successfully updated your password!'
      end
    end
  end
end
