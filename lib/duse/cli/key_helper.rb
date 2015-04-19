module Duse
  module KeyHelper
    def choose_key(options = { allow_generate: true })
      key = nil
      generate_option = 'Generate a new one'
      choose_myself_option = 'Let me choose it myself'
      choices = possible_ssh_keys
      choices << generate_option if options[:allow_generate]
      choices << choose_myself_option
      terminal.choose do |ssh_keys|
        ssh_keys.prompt = 'Which private ssh-key do you want to use?'
        ssh_keys.choices *choices do |choice|
          key = generate_key if choice == generate_option
          key = choose_private_key_file if choice == choose_myself_option
          key ||= OpenSSL::PKey::RSA.new File.read choice
        end
      end
      key
    end

    def ensure_matching_keys_for(user)
      key_pair = {
        public: user.public_key,
        private: private_key_for(user)
      }
      loop do
        break if matching_keys? key_pair
        warn 'Your private key does not match the public key, please select a new one.'
        key_pair[:private] = choose_key(allow_generate: false)
      end
      Duse::CLIConfig.new.save_private_key_for user, key_pair[:private].to_pem
    end

    def private_key_for(user)
      Duse::CLIConfig.new.private_key_for(user)
    rescue PrivateKeyMissing
      warn 'No private key found, please select one.'
      choose_key(allow_generate: false)
    rescue OpenSSL::PKey::RSAError
      warn 'The private key file does not contain a valid private key, please select a new one.'
      choose_key(allow_generate: false)
    end

    def matching_keys?(key_pair)
      public_key = key_pair[:public]
      private_key = key_pair[:private]
      public_key.params['n'] == private_key.params['n']
    end

    def possible_ssh_keys
      ssh_keys = Dir.glob File.join(ssh_dir, '*')
      ssh_keys.keep_if &method(:valid_ssh_private_key?)
    end

    def choose_private_key_file
      private_key_file = nil
      loop do
        private_key_file = terminal.ask('Private key file: ') { |q| q.default = File.join ssh_dir, 'id_rsa' }
        break if valid_ssh_private_key? private_key_file
      end
      OpenSSL::PKey::RSA.new File.read private_key_file
    end

    def valid_ssh_private_key?(private_key_file)
      rsa_key = OpenSSL::PKey::RSA.new File.read private_key_file
      rsa_key.private?
    rescue
      false
    end

    def generate_key
      OpenSSL::PKey::RSA.generate 4096
    end

    def ssh_dir
      File.join home_dir, '.ssh'
    end

    def home_dir
      File.expand_path '~'
    end
  end
end

