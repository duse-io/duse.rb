require 'uri'

module Duse
  module Client
    class Config
      attr_reader :settings

      def initialize(settings = {})
        @settings = settings
      end

      def uri=(uri)
        fail ArgumentError, 'Not an uri' unless uri =~ URI.regexp
        settings['uri'] = uri
      end

      def uri
        settings['uri']
      end

      def token=(token)
        fail ArgumentError, 'Token must be a string'  unless token.is_a? String
        fail ArgumentError, 'Token must not be empty' if token.empty?
        settings['token'] = token
      end

      def token
        settings['token']
      end

      def to_h
        settings.clone
      end
    end
  end
end
