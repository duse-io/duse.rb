require 'duse/cli'

module Duse
  module CLI
    class Login < ApiCommand
      description 'login to access and save secrets'

      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        Duse.uri = config.uri
        response = Duse.session.post('/users/token', { username: username, password: password })
        config.token = response['api_token']
        success 'Successfully logged in!'
      rescue Duse::Client::NotLoggedIn => e
        error e.message.empty? ? 'Wrong username or password!' : e.message
      end
    end
  end
end
