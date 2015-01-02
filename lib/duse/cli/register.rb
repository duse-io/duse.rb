require 'duse/cli'

module Duse
  module CLI
    class Register < ApiCommand
      description 'register a new account'

      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        password_confirmation = terminal.ask('Confirm password: ') { |q| q.echo = 'x' }

        Duse.session = Duse::Client::Session.new uri: config.uri
        user = Duse::User.create(
            username: username,
            password: password,
            password_confirmation: password_confirmation,
            public_key: File.read(File.expand_path('~/.ssh/id_rsa.pem'))
        )

        success 'Successfully created your account! You can now login with "duse login"'
      end
    end
  end
end
