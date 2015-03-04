require 'duse/cli'
require 'duse/cli/key_helper'

module Duse
  module CLI
    class Register < ApiCommand
      include KeyHelper

      description 'Register a new account'

      skip :authenticate

      def run
        ask_for_user_input
        user = Duse::User.create(
          username: @username,
          email: @email,
          password: @password,
          public_key: @key.public_key.to_pem
        )
        Duse::CLIConfig.save_private_key_for user, @key.to_pem
        success 'Successfully created your account! You can now login with "duse login"'
      end

      private

      def ask_for_user_input
        @username = choose_username
        @email = choose_email
        @password = choose_password
        @key = choose_key
      end

      def choose_username
        terminal.ask('Username: ')
      end

      def choose_email
        terminal.ask('Email: ')
      end

      def choose_password
        loop do
          password = terminal.ask('Password: ') { |q| q.echo = 'x' }
          password_confirmation = terminal.ask('Confirm password: ') { |q| q.echo = 'x' }
          return password if password == password_confirmation
          warn 'Password and password confirmation do not match. Try again.'
        end
      end
    end
  end
end
