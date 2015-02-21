require 'duse/cli'
require 'duse/openssh/pub_key'

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

        public_key = File.read(File.expand_path('~/.ssh/id_rsa.pub'))
        public_key = OpenSSH::PubKey.new(public_key).to_rsa
        public_key = public_key.to_pem

        Duse.uri = config.uri
        user = Duse::User.create(
          username: username,
          email: email,
          password: password,
          public_key: public_key
        )

        success 'Successfully created your account! You can now login with "duse login"'
      end
    end
  end
end
