require 'duse/cli'
require 'openssl'
require 'duse/cli/key_helper'
require 'duse/cli/share_with_user'

module Duse
  module CLI
    class UpdateSecret < ApiCommand
      include KeyHelper
      include ShareWithUser

      description 'Save a new secret'

      def run(secret_id = nil)
        secret_id ||= terminal.ask('Secret to update: ').to_i

        current_user = Duse::User.find('me')
        ensure_matching_keys_for current_user
        private_key = config.private_key_for current_user
        secret = Duse::Secret.find secret_id
        print_secret secret, private_key
        secret = update_secret(secret)
        secret_hash  = Duse::Client::SecretMarshaller.new(secret, private_key).to_h

        response = Duse::Secret.update secret_id, secret_hash
        success 'Secret successfully updated!'
      end

      private

      def print_secret(secret, private_key)
        puts "\nName:   #{secret.title}"
        puts "Secret: #{secret.decrypt(private_key)}\n"
      end

      def update_secret(secret)
        title       = terminal.ask 'What do you want to call this secret? ' if terminal.agree 'Change the title? '
        secret_text = terminal.ask 'Secret to save: ' if terminal.agree 'Change the secret? '
        users       = who_to_share_with if terminal.agree 'Change accessible users? '
        Duse::Client::Secret.new title: title, secret_text: secret_text, users: users
      end

      def self.command_name
        'save'
      end
    end
  end
end
