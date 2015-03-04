module Duse
  module CLI
    module ShareWithUser
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
        subjects.each_with_index do |subject, index|
          terminal.say "#{index+1}: #{subject.public_send(method)}"
        end
        selection = terminal.ask 'Separate with commas, to select multiple'
        selection_list = comma_separated_int_list(selection)
        selection_list.map do |i|
          fail InvalidSelection if subjects[i-1].nil?
          subjects[i-1]
        end
      rescue
        warn 'One or more of your selections are invalid. Please try again'
        select_from_list(subjects, method)
      end

      def comma_separated_int_list(string)
        string.split(',').map(&:strip).delete_if(&:empty?).map(&:to_i)
      end
    end
  end
end

