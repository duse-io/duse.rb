module Duse
  module Client
    class Entity
      attr_reader :session, :attributes

      MAP = {}

      def initialize
        @attributes = {}
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
