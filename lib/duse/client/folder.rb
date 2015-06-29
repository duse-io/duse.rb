require 'duse/client/entity'

module Duse
  module Client
    class Folder < Entity
      FOLDER_SYMBOL = '📂'

      attributes :id, :name
      has :secrets
      has :subfolders

      id_field :id
      one  :folder
      one  :subfolder
      many :folders
      many :subfolders

      def children
        self.subfolders + self.secrets
      end

      def id_name
        return "#{FOLDER_SYMBOL}  #{self.name}" if self.id.nil?
        "#{FOLDER_SYMBOL}  #{self.id}: #{self.name}"
      end

      def to_s
        "#{FOLDER_SYMBOL}  #{self.name}"
      end
    end
  end
end
