require 'duse/cli'

module Duse
  module CLI
    class Register < ApiCommand
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
        choose_username
        choose_email
        choose_password
        choose_key
      end

      def choose_username
        @username = terminal.ask('Username: ')
      end

      def choose_email
        @email = terminal.ask('Email: ')
      end

      def choose_password
        loop do
          @password = terminal.ask('Password: ') { |q| q.echo = 'x' }
          password_confirmation = terminal.ask('Confirm password: ') { |q| q.echo = 'x' }
          break if @password == password_confirmation
          warn 'Password and password confirmation do not match. Try again.'
        end
      end

      def choose_key
        @key = nil
        generate_option = 'Generate a new one'
        choose_myself_option = 'Let me choose it myself'
        choices = possible_ssh_keys + [generate_option, choose_myself_option]
        terminal.choose do |ssh_keys|
          ssh_keys.prompt = 'Which private ssh-key do you want to use?'
          ssh_keys.choices *choices do |choice|
            @key = generate_key if choice == generate_option
            @key = choose_private_key_file if choice == choose_myself_option
            @key ||= OpenSSL::PKey::RSA.new File.read choice
          end
        end
        @key
      end

      def possible_ssh_keys
        ssh_keys = Dir.glob File.join(ssh_dir, '*')
        ssh_keys.keep_if &method(:valid_ssh_private_key?)
      end

      def choose_private_key_file
        private_key_file = nil
        loop do
          private_key_file = terminal.ask('Private key file: ') { |q| q.default = File.join ssh_dir, 'id_rsa' }
          break if valid_ssh_private_key? private_key_file
        end
        OpenSSL::PKey::RSA.new File.read private_key_file
      end

      def valid_ssh_private_key?(private_key_file)
        rsa_key = OpenSSL::PKey::RSA.new File.read private_key_file
        rsa_key.private?
      rescue
        false
      end

      def generate_key
        OpenSSL::PKey::RSA.generate 4096
      end

      def ssh_dir
        File.join home_dir, '.ssh'
      end

      def home_dir
        File.expand_path '~'
      end
    end
  end
end
