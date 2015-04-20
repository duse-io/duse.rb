module Duse
  module CLI
    class MetaCommand < Command
      abstract

      def run(*sub_commands)
        say help
      end
    end
  end
end

