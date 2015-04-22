require 'duse/version'
require 'duse/client/entity'
require 'duse/client/secret'
require 'duse/client/user'
require 'duse/client/session'
require 'duse/client/namespace'

module Duse
  include Client::Namespace.new
end
