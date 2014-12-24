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
        selected_users = []
        wants_to_share = terminal.agree 'Do you want to share this secret?[Y/n] '
        if(wants_to_share)
          terminal.say 'Who do you want to share this secret with?'
          users = Duse::User.all
          users.each_with_index do |user, index|
            terminal.say "#{index+1}: #{user.username}"
          end
          user_selection = terminal.ask 'Separate with commas, to select multiple'
          user_selection = comma_separated_int_list(user_selection)
          user_selection.each do |index|
            selected_users << users[index-1] if users[index-1]
          end
        end
        selected_users
      end

      def comma_separated_int_list(string)
        string.split(',').map(&:strip).delete_if(&:empty?).map(&:to_i)
      end
    end
  end
end
