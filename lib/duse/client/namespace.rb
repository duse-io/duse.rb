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

        def update(id, params)
          entity = session.update(type, id, params)
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

        module User
          def current
            find_one 'me'
          end

          def server
            find_one 'server'
          end

          def confirm(token)
            session.patch('/users/confirm', { token: token })
          end

          def password_reset(token, password)
            session.patch('/users/password', {
              token: token,
              password: password
            })
          end

          def forgot_password(email)
            session.post('/users/forgot_password', { email: email })
          end

          def resend_confirmation(email)
            session.post('/users/confirm', { email: email })
          end
        end
      end

      attr_accessor :session

      def initialize
        @session = Session.new

        Entity.subclasses.each do |subclass|
          name = subclass.name[/[^:]+$/]
          curry = Curry.new(self, subclass)
          curry_extension = get_curry_extension(name)
          curry.extend curry_extension if curry_extension
          const_set(name, curry)
        end
      end

      def get_curry_extension(name)
        Curry.const_get(name)
      rescue NameError
        nil
      end

      def included(klass)
        return if klass == Object or klass == Kernel
        namespace = self
        klass.define_singleton_method(:session)  { namespace.session }
        klass.define_singleton_method(:session=) { |value| namespace.session = value }
        klass.define_singleton_method(:config)  { session.config }
        klass.define_singleton_method(:config=) { |value| session.config = value }
      end
    end
  end
end
