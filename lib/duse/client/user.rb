require 'duse/client/entity'
require 'openssl'

module Duse
  module Client
    class User < Entity
      attributes :id, :username, :public_key

      id_field :id
      one  :user
      many :users

      def public_key
        OpenSSL::PKey::RSA.new load_attribute 'public_key'
      end

      def public_key=(public_key)
        public_key = public_key.to_s if public_key.is_a? OpenSSL::PKey::RSA
        set_attribute('public_key', public_key)
      end
    end
  end
end
