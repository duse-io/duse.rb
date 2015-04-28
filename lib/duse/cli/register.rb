require 'duse/cli'
require 'duse/cli/key_helper'
require 'duse/cli/password_helper'

module Duse
  module CLI
    class Register < ApiCommand
      include KeyHelper
      include PasswordHelper

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
        Duse::CLIConfig.new.save_private_key_for user, @key.to_pem
        success 'Successfully created your account! An email to confirm it has been sent. Once confirmed you can login with "duse login"'
      end

      private

      def ask_for_user_input
        @username = choose_username
        @email = choose_email
        @password = ask_for_password
        @key = choose_key
      end

      def choose_username
        terminal.ask('Username: ')
      end

      def choose_email
        terminal.ask('Email: ')
      end
    end
  end
end
