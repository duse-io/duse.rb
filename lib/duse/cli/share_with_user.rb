class CommaSeparatedIntegerList
  def initialize(string)
    @list = string.split(',').map(&:strip).delete_if(&:empty?).map(&:to_i)
  end

  def map(&block)
    @list.map(&block)
  end
end

module Duse
  module CLI
    module ShareWithUser
      class InvalidSelection < StandardError; end

      private

      def who_to_share_with
        required_users = [Duse::User.find('me'), Duse::User.find('server')]
        wants_to_share = terminal.agree 'Do you want to share this secret?[Y/n] '
        return required_users unless wants_to_share
        required_users + select_users(required_users)
      end

      def select_users(ignored_users = [])
        users = Duse::User.all
        users = users.delete_if { |u| ignored_users.map(&:id).include? u.id }
        return [] if users.empty?
        terminal.say 'Who do you want to share this secret with?'
        select_from_list(users, :username)
      end

      def select_from_list(subjects, method = :to_s)
        print_list(subjects, method)
        selection = terminal.ask 'Separate with commas, to select multiple'
        CommaSeparatedIntegerList.new(selection).map do |i|
          fail InvalidSelection if subjects[i-1].nil?
          subjects[i-1]
        end
      rescue InvalidSelection
        warn 'One or more of your selections are invalid. Please try again'
        select_from_list(subjects, method)
      end

      def print_list(items, method = :to_s)
        items.each_with_index do |item, index|
          terminal.say "#{index+1}: #{item.public_send(method)}"
        end
      end
    end
  end
end

