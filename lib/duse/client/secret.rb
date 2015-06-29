require 'duse/client/entity'
require 'duse/encryption'
require 'secret_sharing'

module Duse
  module Client
    class UpdateSecret
      def initialize(secret, values_to_update)
        @secret = secret
        @values = values_to_update
      end

      def encrypt_with(private_key)
        @private_key = private_key
        self
      end

      # Possible Scenarios
      # ------------------
      # change title
      # change secret -> changes cipher + shares
      # change users  -> changes shares
      def build
        result = {}
        result[:title] = @values[:title] if @values[:title]
        result[:folder_id] = @values[:folder_id].to_i if @values[:folder_id]
        if @values[:secret_text]
          users = @secret.users || @values[:current_users]
          cipher_text, shares = Encryption.encrypt(@values[:secret_text], users, @private_key)
          result[:cipher_text] = cipher_text
          result[:shares] = shares
        end
        if @values[:secret_text].nil? && @values[:users]
          shares = @secret.shares.map(&:content)
          symmetric_key = Encryption.decrypt_symmetric_key(shares, @private_key)
          result[:shares] = Encryption.encrypt_symmetric_key(symmetric_key, @values[:users], @private_key)
        end
        result
      end

      def self.values(secret, value_hash)
        new(secret, value_hash)
      end
    end

    class CreateSecret
      class CreatableSecret
        def initialize(options)
          @options = options
        end

        def build
          cipher_text, shares = Encryption.encrypt(@options[:secret_text], @options[:users], @options[:private_key])
          {
            title: @options[:title],
            cipher_text: cipher_text,
            shares: shares,
            folder_id: @options[:folder_id]
          }
        end
      end

      def self.with(options)
        new(options)
      end

      def initialize(options)
        @title = options.fetch(:title)
        @secret_text = options.fetch(:secret_text)
        @users = options.fetch(:users)
        @folder_id = options.fetch(:folder_id, nil)
        @folder_id = @folder_id.to_i if !@folder_id.nil?
      end

      def sign_with(private_key)
        CreatableSecret.new(
          title: @title,
          secret_text: @secret_text,
          users: @users,
          private_key: private_key,
          folder_id: @folder_id
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

        shares = self.shares.map(&:content)
        Encryption.decrypt(self.cipher_text, shares, private_key)
      end

      def signatures_valid?
        self.shares.each do |s|
          return false if !s.valid_signature?
        end
        true
      end

      def to_s
        "🔐  #{self.id}: #{self.title}"
      end
    end

    class Share < Entity
      attributes :id, :content, :signature, :last_edited_by_id

      id_field :id
      one :share
      many :shares

      def valid_signature?
        user = Duse::User.find(self.last_edited_by_id)
        Encryption::Asymmetric.verify(user.public_key, self.signature, self.content)
      end
    end
  end
end
