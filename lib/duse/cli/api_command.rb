module Duse
  module CLI
    class ApiCommand < Command
      abstract

      def requires_authentication?
        true
      end
    end
  end
end
