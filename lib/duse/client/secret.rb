require 'duse/client/entity'
require 'duse/encryption'
require 'secret_sharing'

module Duse
  module Client
    class CreateSecret
      class CreatableSecret
        def initialize(options)
          @options = options
        end

        def build
          cipher_text, shares = encrypt(@options[:secret_text], @options[:users], @options[:private_key])
          {
            title: @options[:title],
            cipher_text: cipher_text,
            shares: shares
          }
        end

        def encrypt(secret_text, users, private_key)
          key, iv, cipher_text = Encryption::Symmetric.encrypt secret_text
          raw_shares = SecretSharing.split_secret "#{key} #{iv}", 2, users.length
          shares = users.map.with_index do |user, index|
            share = raw_shares[index]
            content, signature = Encryption::Asymmetric.encrypt(private_key, user.public_key, share)
            {"user_id" => user.id, "content" => content, "signature" => signature}
          end
          [cipher_text, shares]
        end
      end

      def self.with(options)
        new(options)
      end

      def initialize(options)
        @title = options.fetch(:title)
        @secret_text = options.fetch(:secret_text)
        @users = options.fetch(:users)
      end

      def sign_with(private_key)
        CreatableSecret.new(
          title: @title,
          secret_text: @secret_text,
          users: @users,
          private_key: private_key
        )
      end
    end

    class Secret < Entity
      attributes :id, :title, :shares, :cipher_text
      has :users

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
        Encryption::Symmetric.decrypt(key, iv, self.cipher_text)
      end
    end
  end
end
