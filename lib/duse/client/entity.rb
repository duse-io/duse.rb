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

        list.each do |name|
          add_attribute name.to_s
        end

        @attributes
      end
      self.singleton_class.send :alias_method, :has, :attributes

      def self.add_attribute(name)
        dummy = self.new

        attributes << name
        define_method(name) { load_attribute(name) } unless dummy.respond_to? name
        define_method("#{name}=") { |value| set_attribute(name, value) } unless dummy.respond_to? "#{name}="
        define_method("#{name}?") { !!send(name) } unless dummy.respond_to? "#{name}?"
      end

      def self.id_field(key = nil)
        @id_field = key.to_s if key
        @id_field
      end

      attr_accessor :curry
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
        reload if missing? name
        attributes[name.to_s]
      end

      def reload
        attributes.merge! curry.find_one(id).attributes
      end

      def save
        fail NotImplementedError, 'Save will be the "update" action, once the api supports it'
      end

      def delete
        curry.delete id
      end

      def missing?(name)
        return false unless self.class.attributes.include? name
        !attributes.key?(name)
      end
    end
  end
end
