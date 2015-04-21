module Duse
  module CLI
    class Version < Command
      description 'print the client version'

      def run
        say Duse::VERSION
      end
    end
  end
end

