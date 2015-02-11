require 'duse/cli'

module Duse
  module CLI
    class Register < ApiCommand
      description 'Register a new account'

      skip :authenticate

      def run
        username = terminal.ask('Username: ')
        email = terminal.ask('Email: ')

        password = ''
        password_confirmation = ''
        loop do
          password = terminal.ask('Password: ') { |q| q.echo = 'x' }
          password_confirmation = terminal.ask('Confirm password: ') { |q| q.echo = 'x' }
          break if password == password_confirmation
          warn 'Password and password confirmation do not match. Try again.'
        end

        Duse.uri = config.uri
        user = Duse::User.create(
          username: username,
          email: email,
          password: password,
          public_key: File.read(File.expand_path('~/.ssh/id_rsa.pem'))
        )

        success 'Successfully created your account! You can now login with "duse login"'
      end
    end
  end
end
