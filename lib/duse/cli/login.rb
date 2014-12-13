require 'duse/cli'

module Duse
  module CLI
    class Login < ApiCommand
      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        session = Duse::Client::Session.new uri: CLIConfig.uri
        response = session.raw_post('/v1/users/token', { username: username, password: password })
        
        if response.status == 200
          Duse::CLIConfig.token = response.body['api_token']
          success 'Successfully logged in!'
        end
        if response.status == 401
          error 'Wrong username or password!'
        end
      end
    end
  end
end
