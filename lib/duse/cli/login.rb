require 'duse/cli'

module Duse
  module CLI
    class Login < ApiCommand
      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        client = Duse::Client::Session.new uri: CLIConfig.uri
        response = client.connection.post do |request|
          request.url '/v1/users/token'
          request.body = { username: username, password: password }.to_json
        end
        
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
