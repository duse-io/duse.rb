require 'duse/client/entity'
require 'duse/client/namespace'
require 'duse/client/session'
require 'forwardable'

module Duse
  extend SingleForwardable
  include Client::Namespace.new

  def_delegators :session, :uri=, :token=
  module_function :session
end
