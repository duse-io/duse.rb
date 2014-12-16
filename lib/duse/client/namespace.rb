require 'duse/client/entity'
require 'duse/client/session'

module Duse
  module Client
    class Namespace < Module
      class Curry < Module
        attr_reader :namespace, :type

        def initialize(namespace, type)
          @namespace, @type = namespace, type
        end

        def find_one(id = nil)
          session.find_one(type, id)
        end
        alias_method :find, :find_one

        def create(params)
          session.create(type, params)
        end

        def find_many(params = {})
          session.find_many(type, params)
        end
        alias_method :find_all, :find_many
        alias_method :all, :find_all

        private

        def session
          namespace.session
        end
      end

      attr_accessor :session

      def initialize
        Entity.subclasses.each do |subclass|
          name = subclass.name[/[^:]+$/]
          const_set(name, Curry.new(self, subclass))
        end

        namespace = self
        define_method(:session) { namespace.session }
        define_method(:session=) { |value| namespace.session = value }
      end
    end
  end
end
