require 'duse/client/entity'
require 'duse/client/secret'
require 'duse/client/user'
require 'duse/client/session'
require 'duse/client/namespace'
require 'forwardable'

module Duse
  extend SingleForwardable
  include Client::Namespace.new

  def_delegators :session, :config, :config=
  module_function :session
end
