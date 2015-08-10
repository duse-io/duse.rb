require 'openssl'
require 'digest/sha2'
require 'base64'

module Duse
  module Encryption
    module Digest
      def digest
        OpenSSL::Digest::SHA256.new
      end
    end

    module Encoding
      def encode(plain_text)
        Base64.encode64(plain_text).encode('utf-8')
      end

      def decode(encoded_text)
        Base64.decode64(encoded_text.encode('ascii-8bit')).force_encoding('utf-8')
      end
    end

    module Asymmetric
      extend self
      extend Duse::Encryption::Encoding
      extend Duse::Encryption::Digest
      PADDING = OpenSSL::PKey::RSA::PKCS1_PADDING

      def encrypt(private_key, public_key, text)
        encrypted = public_key.public_encrypt text.force_encoding('ascii-8bit'), PADDING
        signature = sign(private_key, encrypted)
        { cipher: encode(encrypted), signature: signature }
      end

      def sign(private_key, text)
        encode(private_key.sign(digest, text))
      end

      def decrypt(private_key, text)
        private_key.private_decrypt(decode(text), PADDING).force_encoding('utf-8')
      end

      def verify(public_key, signature, encrypted)
        public_key.verify digest, decode(signature), decode(encrypted)
      end
    end

    module Symmetric
      extend self
      extend Duse::Encryption::Encoding

      def encrypt(plaintext)
        plaintext = encode(plaintext)
        cipher = symmetric_algorithm
        cipher.encrypt
        key = cipher.random_key
        iv = cipher.random_iv

        cipher_text = cipher.update(plaintext)
        cipher_text << cipher.final

        [encode(key), encode(iv), encode(cipher_text)]
      end

      def decrypt(key, iv, cipher_text)
        key = decode(key)
        iv = decode(iv)
        cipher_text = decode(cipher_text)

        cipher = symmetric_algorithm
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv

        plaintext = cipher.update(cipher_text)
        plaintext << cipher.final
        decode(plaintext)
      end

      def symmetric_algorithm
        OpenSSL::Cipher.new('AES-256-CBC')
      end
    end

    module CryptographicHash
      extend self
      extend Duse::Encryption::Encoding
      extend Duse::Encryption::Digest

      def hmac(key, data)
        encode(OpenSSL::HMAC.digest(digest, key, data))
      end
    end

    extend self

    def hmac(key, data)
      Duse::Encryption::CryptographicHash.hmac(key, data)
    end

    def encrypt(secret_text, users, private_key)
      key, iv, cipher_text = Encryption::Symmetric.encrypt secret_text
      shares = encrypt_symmetric_key("#{key.strip} #{iv.strip}", users, private_key)
      [cipher_text, shares]
    end

    def decrypt(cipher_text, shares, private_key)
      key, iv = decrypt_symmetric_key(shares, private_key).split ' '
      Encryption::Symmetric.decrypt(key, iv, cipher_text)
    end

    def encrypt_symmetric_key(symmetric_key, users, private_key)
      raw_shares = SecretSharing.split(symmetric_key, 2, users.length)
      users.map.with_index do |user, index|
        share = raw_shares[index]
        result = Encryption::Asymmetric.encrypt(private_key, user.public_key, share)
        {
          "user_id" => user.id,
          "content" => result.fetch(:cipher),
          "signature" => result.fetch(:signature)
        }
      end
    end

    def decrypt_symmetric_key(shares, private_key)
      raw_shares = shares.map do |share|
        Encryption::Asymmetric.decrypt private_key, share
      end
      SecretSharing.reconstruct(raw_shares)
    end
  end
end

