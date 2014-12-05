require 'highline'

module Duse
  module CLI
    class Command
      attr_reader :output, :input
      attr_accessor :arguments

      def initialize
        self.output      = $stdout
        self.input       = $stdin
        self.arguments ||= []
      end

      def parse(args)
        parser = OptionParser.new
        arguments.concat(parser.parse(args))
      end

      def execute
        puts "executing #{self.class}"
      end

      def output=(io)
        @terminal = nil
        @output = io
      end

      def input=(io)
        @terminal = nil
        @input = io
      end

      def terminal
        @terminal ||= HighLine.new(input, output)
      end

      # ignore Command since its not supposed to be executed
      @@abstract ||= [Command]
      def self.abstract?
        @@abstract.include? self
      end

      def self.abstract
        @@abstract << self
      end
    end
  end
end
