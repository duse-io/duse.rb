require 'duse/cli'
require 'duse/cli/key_helper'

module Duse
  module CLI
    class UpdateAccount < ApiCommand
      include KeyHelper

      description 'update account'

      def run
        user = Duse::User.find('me')
        terminal.say 'Leave blank if you do not wish to change'
        user.username = terminal.ask('Username: ') { |q| q.default = user.username }
        user.email = terminal.ask('Email: ') { |q| q.default = user.email }
        current_password = terminal.ask('Current password (to confirm): ') { |q| q.echo = 'x' }
        Duse::User.update(user.id, user.to_h.merge({ current_password: current_password }))
        success 'Successfully updated your account!'
      end
    end
  end
end
