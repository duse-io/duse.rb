module Duse
  module Client
    class Entity
      attr_reader :session, :attributes
      alias_method :to_h, :attributes

      MAP = {}

      def initialize(options = {})
        @attributes = {}
        options.each do |key, value|
          self.send "#{key.to_s}=", value
        end
      end

      def self.base_path
        many
      end

      def self.subclasses
        MAP.values.uniq
      end

      def self.one(key = nil)
        MAP[key.to_s] = self if key
        @one ||= key.to_s
      end

      def self.many(key = nil)
        MAP[key.to_s] = self if key
        @many ||= key.to_s
      end

      def self.attributes(*list)
        @attributes ||= []

        dummy = self.new
        list.each do |name|
          name = name.to_s
          fail "can't call an attribute id" if name == "id"

          @attributes << name
          define_method(name) { load_attribute(name) } unless dummy.respond_to? name
          define_method("#{name}=") { |value| set_attribute(name, value) } unless dummy.respond_to? "#{name}="
          define_method("#{name}?") { !!send(name) } unless dummy.respond_to? "#{name}?"
        end

        @attributes
      end
      self.singleton_class.send :alias_method, :has, :attributes

      def set_attribute(name, value)
        attributes[name.to_s] = value
      end

      def load_attribute(name)
        session.reload(self) if missing? name
        attributes[name.to_s]
      end

      def missing?(key)
        return false unless include? key
        !attributes.include?(key.to_s)
      end

      def include?(key)
        attributes.include? key or attribute_names.include? key.to_s
      end
    end

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
        secret_text_in_slices_of(50).map do |secret_part|
          # the selected users + current user + server
          threshold = @users.length+2
          shares = SecretSharing.split_secret(secret_part, 2, threshold)
          server_share, server_sign = Duse::Encryption.encrypt(@private_key, @server_user.public_key,  shares[0])
          user_share,   user_sign   = Duse::Encryption.encrypt(@private_key, @current_user.public_key, shares[1])
          part = [
            {"user_id" => "server", "content" => server_share, "signature" => server_sign},
            {"user_id" => "me"    , "content" => user_share,   "signature" => user_sign},
          ]
          #shares[2..shares.length].each_with_index do |share, index|
          #  part["#{users[index]}"] = shares[index+2]
          #end
          part
        end
      end

      def secret_text_in_slices_of(piece_size)
        @secret.secret_text.chars.each_slice(piece_size).map(&:join)
      end
    end

    class Secret < Entity
      attributes :title, :required
      has :users

      attr_accessor :secret_text

      one  :secret
      many :secrets
    end

    class User < Entity
      attributes :username, :public_key

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
