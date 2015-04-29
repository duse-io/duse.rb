require 'duse/client/entity'
require 'duse/encryption'
require 'secret_sharing'

module Duse
  module Client
    class Secret < Entity
      attributes :id, :title, :shares, :cipher_text
      has :users

      attr_accessor :secret_text

      id_field :id
      one  :secret
      many :secrets

      def decrypt(private_key)
        # require private_key to be private rsa key
        # require shares to be set (real shares object in the future)
        # require cipher_text to be set

        raw_shares = self.shares.map do |share|
          Encryption::Asymmetric.decrypt private_key, share
        end
        key, iv = SecretSharing.recover_secret(raw_shares).split ' '
        self.secret_text = Encryption::Symmetric.decrypt key, iv, cipher_text
      end

      def encrypt(private_key)
        # require private_key to be private rsa key
        # require users to be set and user objects
        # require secret_text to be set and string

        key, iv, self.cipher_text = Encryption::Symmetric.encrypt secret_text
        raw_shares = SecretSharing.split_secret "#{key} #{iv}", 2, self.users.length
        self.shares = users.map.with_index do |user, index|
          share = raw_shares[index]
          content, signature = Encryption::Asymmetric.encrypt(private_key, user.public_key, share)
          {"user_id" => user.id, "content" => content, "signature" => signature}
        end
      end
    end
  end
end
