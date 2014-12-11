require 'secret_sharing'
require 'duse/cli'
require 'json'
require 'openssl'
require 'duse/encryption'

module Duse
  module CLI
    class Share < ApiCommand
      def run
        title  = terminal.ask 'What do you want to call this secret? '
        secret = terminal.ask 'Secret to save: '
        users  = who_to_share_with

        client = Duse::Client::Session.new(CLIConfig.uri, CLIConfig.token)
        current_user = client.find_one(Duse::Client::User, 'me')
        server_user  = client.find_one(Duse::Client::User, 'server')
        user_private_key  = OpenSSL::PKey::RSA.new File.read File.expand_path '~/.ssh/id_rsa'
        parts = secret.chars.each_slice(50).map(&:join).map do |secret_part|
          # the selected users + current user + server
          threshold = users.length+2
          shares = SecretSharing.split_secret(secret_part, 2, threshold)
          server_share, server_sign = Duse::Encryption.encrypt(user_private_key, server_user.public_key, shares[0])
          user_share, user_sign     = Duse::Encryption.encrypt(user_private_key, current_user.public_key,   shares[1])
          part = {
            "server" => {"share" => server_share, "signature" => server_sign},
            "me"     => {"share" => user_share,   "signature" => user_sign},
          }
          shares[2..shares.length].each_with_index do |share, index|
            part["#{users[index]}"] = shares[index+2]
          end
          part
        end

        secret = {
          title: title,
          required: 2,
          parts: parts
        }

        response = client.create(Duse::Client::Secret, secret)
        if response.status == 201
          success 'Secret successfully created!'
        else
          error "Something went wrong. (#{response.status}, #{response.body})"
        end
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
