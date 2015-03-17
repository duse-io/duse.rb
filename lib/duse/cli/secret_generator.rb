require 'securerandom'

module Duse
  class SecretGenerator
    def generated_password
      SecureRandom.base64(32)
    end
  end
end

