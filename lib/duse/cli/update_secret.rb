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

      def run(*arguments)
        secret_id = arguments.shift unless arguments.empty?
        secret_id ||= terminal.ask('Secret to update: ').to_i

        current_user = Duse::User.find('me')
        ensure_matching_keys_for current_user
        server_user  = Duse::User.find('server')
        secret       = Duse::Secret.find secret_id
        private_key  = Duse::CLIConfig.private_key_for current_user

        puts "\nName:   #{secret.title}"
        puts "Secret: #{secret.decrypt(private_key)}\n"

        hash                = {}
        hash[:title]        = terminal.ask 'What do you want to call this secret? ' if terminal.agree 'Change the title? '
        hash[:secret_text]  = terminal.ask 'Secret to save: ' if terminal.agree 'Change the secret? '
        users               = secret.users.delete_if { |user| user.id == current_user.id || user.id == server_user.id }
        users               = who_to_share_with if terminal.agree 'Change accessible users? '

        secret       = Duse::Client::Secret.new hash
        secret_hash  = Duse::Client::SecretMarshaller.new(secret, private_key, users, current_user, server_user).to_h

        response = Duse::Secret.update secret_id, secret_hash
        success 'Secret successfully updated!'
      end

      private

      def self.command_name
        'save'
      end
    end
  end
end
