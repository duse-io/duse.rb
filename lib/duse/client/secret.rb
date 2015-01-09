require 'duse/client/entity'
require 'duse/encryption'
require 'secret_sharing'

module Duse
  module Client
    class SecretMarshaller
      def initialize(secret, private_key, users, current_user, server_user)
        @secret       = secret
        @private_key  = private_key
        @users        = users
        @current_user = current_user
        @server_user  = server_user
      end

      def to_h
        secret_hash = @secret.attributes
        secret_hash['parts'] = parts_from_secret
        secret_hash
      end

      def parts_from_secret
        # sliced of 18 is a result of trial & error, if it's too large then
        # encryption will fail. Might improve with: http://stackoverflow.com/questions/11505547/how-calculate-size-of-rsa-cipher-text-using-key-size-clear-text-length
        secret_text_in_slices_of(18).map do |secret_part|
          # the selected users + current user + server
          number_of_shares = 2 + @users.length
          shares = SecretSharing.split_secret(secret_part, 2, number_of_shares)
          server_share, server_sign = Duse::Encryption.encrypt(@private_key, @server_user.public_key,  shares[0])
          user_share,   user_sign   = Duse::Encryption.encrypt(@private_key, @current_user.public_key, shares[1])
          part = [
            {"user_id" => "server", "content" => server_share, "signature" => server_sign},
            {"user_id" => "me"    , "content" => user_share,   "signature" => user_sign},
          ]
          shares[2..shares.length].each_with_index do |share, index|
            user = @users[index]
            content, signature = Duse::Encryption.encrypt(@private_key, user.public_key, shares[index+2])
            part << {"user_id" => user.id, "content" => content, "signature" => signature}
          end
          part
        end
      end

      def secret_text_in_slices_of(piece_size)
        @secret.secret_text.chars.each_slice(piece_size).map(&:join)
      end
    end

    class Secret < Entity
      attributes :id, :title, :shares
      has :users

      attr_accessor :secret_text

      id_field :id
      one  :secret
      many :secrets

      def decrypt(private_key)
        @secret_text ||= shares(private_key).inject('') do |result, shares|
          result << SecretSharing.recover_secret(shares)
        end
      end

      def shares(private_key)
        return nil if load_attribute('shares').nil?
        load_attribute('shares').map do |part|
          part.map do |share|
            Duse::Encryption.decrypt private_key, share
          end
        end
      end
    end
  end
end
