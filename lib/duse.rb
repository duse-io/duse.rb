require 'duse/client/entity'
require 'duse/client/namespace'
require 'duse/client/session'

module Duse
  include Client::Namespace.new

  def uri=(uri)
    session.uri = uri
  end

  def token=(token)
    session.token = token
  end

  module_function :session, :session=, :uri=, :token=
  public :session, :session=
end
