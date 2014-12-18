require 'secret_sharing'
require 'duse/cli'
require 'json'
require 'openssl'
require 'duse/encryption'

module Duse
  module CLI
    class SaveSecret < ApiCommand
      def run(*arguments)
        title       = terminal.ask 'What do you want to call this secret? '
        secret_text = terminal.ask 'Secret to save: '
        users       = who_to_share_with

        current_user = Duse::User.find('me')
        server_user  = Duse::User.find('server')
        private_key  = OpenSSL::PKey::RSA.new File.read File.expand_path '~/.ssh/id_rsa'
        secret       = Duse::Client::Secret.new title: title, required: 2, secret_text: secret_text
        secret_hash  = Duse::Client::SecretMarshaller.new(secret, private_key, users, current_user, server_user).to_h

        response = Duse::Secret.create secret_hash
        success 'Secret successfully created!'
      end

      private

      def who_to_share_with
        user_ids = []
        wants_to_share = terminal.agree 'Do you want to share this secret?[Y/n] '
        if(wants_to_share)
          terminal.say 'Who do you want to share this secret with?'
          users = [{id: 1, username: 'adracus'}, {id: 2, username: 'flower-pot'}]
          users.each_with_index do |user, index|
            terminal.say "#{index+1}: #{user[:username]}"
          end
          user_selection = terminal.ask 'Separate with commas, to select multiple'
          comma_separated_int_list(user_selection).each do |index|
            user_ids << users[index-1][:id] if users[index-1]
          end
        end
        user_ids
      end

      def comma_separated_int_list(string)
        string.split(',').map(&:strip).delete_if(&:empty?).map(&:to_i)
      end
    end
  end
end
