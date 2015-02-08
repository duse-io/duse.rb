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

        secret      = Duse::Secret.find secret_id
        private_key = OpenSSL::PKey::RSA.new File.read File.expand_path '~/.ssh/id_rsa'

        if plain?
          say secret.decrypt(private_key)
          return
        end

        say <<-SECRET_DESCRIPTION.gsub /^( |\t)+/, ""

          Name:   #{secret.title}
          Secret: #{secret.decrypt(private_key)}
          Access: #{secret.users.map(&:username).join(', ')}
        SECRET_DESCRIPTION
      end

      def self.command_name
        'get'
      end
    end
  end
end
