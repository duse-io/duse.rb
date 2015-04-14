require 'duse/cli'
require 'duse/cli/key_helper'
require 'duse/cli/password_helper'

module Duse
  module CLI
    class UpdateAccount < ApiCommand
      include KeyHelper
      include PasswordHelper

      description 'update account'

      def run
        user = Duse::User.find('me')
        terminal.say 'Leave blank if you do not wish to change'
        Duse::User.update(user.id, {
          username: terminal.ask('Username: ') { |q| q.default = user.username },
          email: terminal.ask('Email: ') { |q| q.default = user.email },
          current_password: ask_for_current_password
        })
        success 'Successfully updated your account!'
      end
    end
  end
end
