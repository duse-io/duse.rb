require 'duse/cli'
require 'openssl'
require 'duse/cli/key_helper'

module Duse
  module CLI
    class SecretGet < ApiCommand
      include KeyHelper
      description 'Retrieve a secret'

      on('-p', '--plain', 'Print the decrypted secret plain, without additional information.')

      def run(secret_id = nil)
        if secret_id.nil?
          secrets = Duse::Secret.all
          secrets.each do |s|
            say "#{s.id}: #{s.title}"
          end
          secret_id = terminal.ask("\nSelect the id of the secret to retrieve: ").to_i
        end

        secret = Duse::Secret.find secret_id
        print_secret(secret)
      end

      def print_secret(secret)
        user = Duse::User.current
        ensure_matching_keys_for user
        private_key = config.private_key_for user
        plain_secret = secret.decrypt(private_key)

        if plain?
          print plain_secret
          $stdout.flush
          return
        end

        say "
          Name:   #{secret.title}
          Secret: #{plain_secret}
          Access: #{secret.users.delete_if(&:server?).map(&:username).join(', ')}
        ".gsub(/^( |\t)+/, "")
      end
    end
  end
end
