require 'openssl'
require 'digest/sha2'
require 'base64'

module Duse
  module Encryption
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

      def encrypt(private_key, public_key, text)
        encrypted = public_key.public_encrypt text.force_encoding('ascii-8bit')
        signature = sign(private_key, encrypted)
        [encode(encrypted), signature]
      end

      def sign(private_key, text)
        encode(private_key.sign(digest, text))
      end

      def decrypt(private_key, text)
        private_key.private_decrypt(decode(text)).force_encoding('utf-8')
      end

      def verify(public_key, signature, encrypted)
        public_key.verify digest, decode(signature), decode(encrypted)
      end

      def digest
        OpenSSL::Digest::SHA256.new
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
  end
end

