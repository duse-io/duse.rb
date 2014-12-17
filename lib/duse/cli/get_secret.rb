require 'secret_sharing'
require 'duse/cli'
require 'json'
require 'openssl'
require 'duse/encryption'

module Duse
  module CLI
    class GetSecret < ApiCommand
      def run
        secret_id = terminal.ask('Secret to retrieve: ').to_i

        client      = Duse::Client::Session.new(uri: CLIConfig.uri, token: CLIConfig.token)
        secret      = client.find_one(Duse::Client::Secret, secret_id)
        private_key = OpenSSL::PKey::RSA.new File.read File.expand_path '~/.ssh/id_rsa'

        puts "Name: #{secret.title}"
      end
    end
  end
end
