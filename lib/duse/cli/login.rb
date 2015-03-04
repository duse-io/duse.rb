require 'duse/cli'
require 'duse/cli/key_helper'

module Duse
  module CLI
    class Login < ApiCommand
      include KeyHelper

      description 'login to access and save secrets'

      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        response = Duse.session.post('/users/token', { username: username, password: password })
        config.token = response['api_token']
        Duse.token = response['api_token']
        user = Duse::User.find 'me'
        ensure_matching_keys_for user
        success 'Successfully logged in!'
      rescue Duse::Client::NotLoggedIn => e
        error e.message.empty? ? 'Wrong username or password!' : e.message
      end
    end
  end
end
