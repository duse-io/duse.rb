require 'duse/cli'
require 'tree_outline'

module Duse
  module CLI
    class SecretTree < ApiCommand
      description 'Print all secrets you have access to in a tree'

      def run
        root_folders = Duse::Folder.all
        say TreeOutline.new(root_folders.first).to_s
      end
    end
  end
end
