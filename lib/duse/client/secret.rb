require 'duse/client/entity'
require 'duse/encryption'
require 'secret_sharing'

module Duse
  module Client
    class SecretMarshaller
      def initialize(secret, private_key)
        @secret       = secret
        @private_key  = private_key
      end

      def to_h
        secret_hash = {}
        secret_hash['title'] = @secret.title     if @secret.title
        secret_hash['parts'] = parts_from_secret if @secret.secret_text
        secret_hash
      end

      def parts_from_secret
        # sliced of 18 is a result of trial & error, if it's too large then
        # encryption will fail. Might improve with: http://stackoverflow.com/questions/11505547/how-calculate-size-of-rsa-cipher-text-using-key-size-clear-text-length
        secret_text_in_slices_of(18).map do |secret_part|
          shares = SecretSharing.split_secret(secret_part, 2, @secret.users.length)
          @secret.users.each_with_index.map do |user, index|
            share = shares[index]
            content, signature = Duse::Encryption.encrypt(@private_key, user.public_key, share)
            {"user_id" => "#{user.id}", "content" => content, "signature" => signature}
          end
        end
      end

      def secret_text_in_slices_of(piece_size)
        @secret.secret_text.chars.each_slice(piece_size).map(&:join)
      end
    end

    class Secret < Entity
      attributes :id, :title, :parts
      has :users

      attr_accessor :secret_text

      id_field :id
      one  :secret
      many :secrets

      def decrypt(private_key)
        @secret_text ||= parts(private_key).inject('') do |result, shares|
          result << SecretSharing.recover_secret(shares)
        end
      end

      def parts(private_key)
        return nil if load_attribute('parts').nil?
        load_attribute('parts').map do |part|
          part.map do |share|
            Duse::Encryption.decrypt private_key, share
          end
        end
      end
    end
  end
end
