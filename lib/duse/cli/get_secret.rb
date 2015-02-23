require 'duse/cli'
require 'openssl'

module Duse
  module CLI
    class GetSecret < ApiCommand
      description 'Retrieve a secret'

      on('-p', '--plain', 'Print the decrypted secret plain, without additional information.')

      def run(*arguments)
        secret_id = arguments.shift unless arguments.empty?
        secret_id ||= terminal.ask('Secret to retrieve: ').to_i

        secret = Duse::Secret.find secret_id

        say render(secret)
      end

      def render(secret)
        private_key = config.private_key_for Duse::User.find 'me'
        plain_secret = secret.decrypt(private_key)

        if plain?
          return plain_secret
        end
        
        "
          Name:   #{secret.title}
          Secret: #{plain_secret}
          Access: #{secret.users.map(&:username).join(', ')}
        ".gsub(/^( |\t)+/, "")
      end

      def self.command_name
        'get'
      end
    end
  end
end
