require 'secret_sharing'
require 'duse/cli'
require 'json'
require 'openssl'
require 'duse/encryption'

module Duse
  module CLI
    class GetSecret < ApiCommand
      def run(*arguments)
        secret_id = arguments.shift unless arguments.empty?
        secret_id ||= terminal.ask('Secret to retrieve: ').to_i

        secret      = Duse::Secret.find secret_id
        private_key = OpenSSL::PKey::RSA.new File.read File.expand_path '~/.ssh/id_rsa'

        puts "Name:   #{secret.title}"
        puts "Secret: #{secret.decrypt(private_key)}"
      end
    end
  end
end
