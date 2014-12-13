require 'duse/client/entity'
require 'duse/client/namespace'
require 'duse/client/session'

module Duse
  include Client::Namespace.new

  module_function :session, :session=
  public :session, :session=
end
