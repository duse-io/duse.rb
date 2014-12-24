module Duse
  module Client
    class Entity
      MAP = {}

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

          @attributes << name
          define_method(name) { load_attribute(name) } unless dummy.respond_to? name
          define_method("#{name}=") { |value| set_attribute(name, value) } unless dummy.respond_to? "#{name}="
          define_method("#{name}?") { !!send(name) } unless dummy.respond_to? "#{name}?"
        end

        @attributes
      end
      self.singleton_class.send :alias_method, :has, :attributes

      def self.cast_id(id)
        Integer(id)
      end

      def self.id?(object)
        object.is_a? Integer
      end

      def self.id_field(key = nil)
        @id_field = key.to_s if key
        @id_field
      end

      attr_accessor :session
      attr_reader :attributes
      alias_method :to_h, :attributes

      def initialize(options = {})
        @attributes = {}
        options.each do |key, value|
          self.send("#{key.to_s}=", value) if respond_to? "#{key.to_s}="
        end
      end

      def set_attribute(name, value)
        attributes[name.to_s] = value
      end

      def load_attribute(name)
        session.reload(self) if missing? name
        attributes[name.to_s]
      end

      def missing?(name)
        return false unless self.class.attributes.include? name
        !attributes.key?(name)
      end

      def session
        Duse.session
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
        # sliced of 18 is a result of trial & error, if it's too large then
        # encryption will fail. Might improve with: http://stackoverflow.com/questions/11505547/how-calculate-size-of-rsa-cipher-text-using-key-size-clear-text-length
        secret_text_in_slices_of(18).map do |secret_part|
          # the selected users + current user + server
          threshold = @users.length+2
          shares = SecretSharing.split_secret(secret_part, 2, threshold)
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
      attributes :id, :title, :required, :shares
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
