require 'duse/cli/folder_list'
require 'duse/cli/folder_add'
require 'duse/cli/folder_remove'
require 'duse/cli/folder_update'

module Duse
  module CLI
    class Folder < MetaCommand
      subcommand FolderList
      subcommand FolderAdd
      subcommand FolderRemove
      subcommand FolderUpdate

      description 'Manage your folders'
    end
  end
end

