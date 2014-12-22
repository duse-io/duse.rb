require 'duse/cli'

module Duse
  module CLI
    class Login < ApiCommand
      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        session = Duse::Client::Session.new uri: CLIConfig.uri
        response = session.post('/v1/users/token', { username: username, password: password })
        Duse::CLIConfig.token = response['api_token']
        success 'Successfully logged in!'
      rescue Duse::Client::NotLoggedIn
        error 'Wrong username or password!'
      end
    end
  end
end
