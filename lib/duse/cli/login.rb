require 'duse/cli'

module Duse
  module CLI
    class Login < ApiCommand
      description 'login to access and save secrets'

      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        session = Duse::Client::Session.new uri: config.uri
        response = session.post('/v1/users/token', { username: username, password: password })
        config.token = response['api_token']
        success 'Successfully logged in!'
      rescue Duse::Client::NotLoggedIn
        error 'Wrong username or password!'
      end
    end
  end
end
