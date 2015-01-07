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

        def find_one(id)
          entity = session.find_one(type, id)
          entity.curry = self
          entity
        end
        alias_method :find, :find_one
        alias_method :get, :find_one

        def create(params)
          entity = session.create(type, params)
          entity.curry = self
          entity
        end

        def delete(id)
          session.delete_one(type, id)
        end

        def find_many(params = {})
          session.find_many(type, params).each do |e|
            e.curry = self
          end
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
        define_method(:session) { namespace.session ||= Session.new }
      end
    end
  end
end
