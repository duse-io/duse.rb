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
            session.post('/users/forgot_password', { email: self.email })
          end

          def resend_confirmation(email)
            session.post('/users/confirm', { email: self.email })
          end
        end
      end

      attr_accessor :session

      def initialize
        Entity.subclasses.each do |subclass|
          name = subclass.name[/[^:]+$/]
          curry = Curry.new(self, subclass)
          curry_extension = get_curry_extension(name)
          curry.extend curry_extension if curry_extension
          const_set(name, curry)
        end

        namespace = self
        define_method(:session) { namespace.session ||= Session.new }
      end

      def get_curry_extension(name)
        Curry.const_get(name)
      rescue NameError
        nil
      end
    end
  end
end
