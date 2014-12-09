module Duse
  module Client
    class Entity
      attr_reader :session

      MAP = {}

      def self.base_path
        many
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

        list.each do |name|
          name = name.to_s
          fail "can't call an attribute id" if name == "id"

          @attributes << name
          define_method(name) { load_attribute(name) }
          define_method("#{name}=") { |value| set_attribute(name, value) }
          define_method("#{name}?") { !!send(name) }
        end

        @attributes
      end
    end

    class Secret < Entity
      attributes :title, :required

      one  :secret
      many :secrets
    end

    class User < Entity
      attributes :username, :public_key

      one  :user
      many :users
    end
  end
end
