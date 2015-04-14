module Duse
  module PasswordHelper
    def ask_for_password
      loop do
        password = terminal.ask('Password: ') { |q| q.echo = 'x' }
        password_confirmation = terminal.ask('Confirm password: ') { |q| q.echo = 'x' }
        return password if password == password_confirmation
        warn 'Password and password confirmation do not match. Try again.'
      end
    end

    def ask_for_current_password
      terminal.ask('Current password (to confirm): ') { |q| q.echo = 'x' }
    end
  end
end

