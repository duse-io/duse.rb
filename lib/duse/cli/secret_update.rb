require 'duse/cli'
require 'openssl'
require 'duse/cli/key_helper'
require 'duse/cli/share_with_user'

module Duse
  module CLI
    class SecretUpdate < ApiCommand
      include KeyHelper
      include ShareWithUser

      description 'Save a new secret'

      def run(secret_id = nil)
        secret_id ||= terminal.ask('Secret to update: ').to_i

        user = Duse::User.current
        ensure_matching_keys_for user
        private_key = config.private_key_for user
        secret = Duse::Secret.find secret_id
        print_secret secret, private_key
        secret_hash = Duse::Client::UpdateSecret.values(secret, values_to_update).encrypt_with(private_key).build

        response = Duse::Secret.update secret_id, secret_hash
        success 'Secret successfully updated!'
      end

      private

      def print_secret(secret, private_key)
        puts "\nName:   #{secret.title}"
        puts "Secret: #{secret.decrypt(private_key)}\n"
      end

      def values_to_update
        title       = terminal.ask 'What do you want to call this secret? ' if terminal.agree 'Change the title? '
        secret_text = terminal.ask 'Secret to save: ' if terminal.agree 'Change the secret? '
        users       = who_to_share_with if terminal.agree 'Change accessible users? '
        { title: title, secret_text: secret_text, users: users }.delete_if { |k, v| v.nil? }
      end
    end
  end
end
