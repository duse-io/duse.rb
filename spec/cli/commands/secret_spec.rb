# encoding: UTF-8

RSpec.describe 'duse secret', :fs => :fake do
  before :each do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    open(Duse::CLIConfig.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
      f.puts 'token: token'
    end
    open(File.join(Duse::CLIConfig.config_dir, 'flower-pot'), 'w') do |f|
      f.puts user_private_key.to_s
    end
  end

  describe 'get' do
    context 'provide secret id from the call' do
      it 'takes the secrets id from the cli call and does not ask for it' do
        stub_secret_get
        stub_user_me_get
        stub_server_user_get
        stub_user_get1
        stub_user_get2
        expect(run_cli('secret', 'get', '1').out).to eq(
          "\nName:   test\nSecret: test\nAccess: flower-pot\n"
        )
      end

      it 'takes the secrets id from the cli call and does not ask for it' do
        stub_secret_get
        stub_user_me_get
        stub_secret_get_broken_signature
        stub_user_get1
        stub_user_get2
        expect(run_cli('secret', 'get', '2').err).to eq(
          "Signatures could not be verified!\nEither a user is changing her keypair\nor there is an attacker.\n"
        )
      end

      it 'outputs the secret content plaintext when using the plain flag' do
        stub_secret_get
        stub_user_me_get
        stub_server_user_get
        expect(run_cli('secret', 'get', '1', '--plain').out).to eq("test")
      end
    end

    context 'secret does not exist' do
      it 'shows an error message when getting not existant secrets' do
        stub_request(:get, "https://example.com/secrets/2").
          with(headers: {'Accept'=>'application/vnd.duse.1+json', 'Authorization'=>'token'}).
          to_return(status: 404, body: { message: 'Not found' }.to_json)

        expect(run_cli('secret', 'get', '2').err).to eq(
          "Not found\n"
        )
      end
    end

    context 'secret exists' do
      it 'asks for the secret id' do
        stub_get_secrets
        stub_secret_get
        stub_user_me_get
        stub_server_user_get
        stub_user_get1
        stub_user_get2

        run_cli('secret', 'get') { |i| i.puts('1') }

        expect(last_run.out).to match(
          "1: test\n\nSelect the id of the secret to retrieve: (1\n)?\nName:   test\nSecret: test\nAccess: flower-pot\n"
        )
        expect(last_run.err).to be_empty
      end
    end
  end

  describe 'tree' do
    xit 'prints the secrets in folder/secrets tree' do
      stub_get_folders

      expect(run_cli('secret', 'tree').out).to eq(
        "1: test\n"
      )
    end
  end

  describe 'list' do
    it 'lists secrets as id:secret pairs' do
      stub_get_secrets

      run_cli('secret', 'list')
      output = last_run.out
      expect(output).to eq(
        "🔐  1: test\n"
      )
    end
  end

  describe 'delete' do
    it 'deletes the provided secret id' do
      stub_request(:delete, "https://example.com/secrets/1").
        with(headers: {'Accept'=>'application/vnd.duse.1+json', 'Authorization'=>'token'}).
        to_return(status: 204, body: "", headers: {})

      expect(run_cli('secret', 'remove', '1').success?).to be true
    end
  end

  describe 'add' do
    context 'minimal users' do
      it 'can create a secret' do
        stub_get_users
        stub_user_me_get
        stub_server_user_get
        stub_create_secret

        expect(run_cli('secret', 'add') do |i|
          i.puts 'test'
          i.puts 'test'
          i.puts 'n'
          i.puts 'n'
        end.success?).to be true
      end
    end

    context 'multiple users' do
      it 'can create a secret with multiple users' do
        stub_get_users
        stub_user_me_get
        stub_server_user_get
        stub_get_other_user
        stub_create_secret

        expect(run_cli('secret', 'add') do |i|
          i.puts 'test'
          i.puts 'test'
          i.puts 'y'
          i.puts '1'
          i.puts 'n'
        end.success?).to be true

        expect(last_run.out).to match(
          /What do you want to call this secret\? (test\n)?Secret to save: (test\n)?Do you want to share this secret\?\[y\/n\] (y\n)?Who do you want to share this secret with\?\n1: adracus\nType the ids of the users you want to share with \(separate with commas to select multiple\)\n(1\n)?/
        )
      end
    end

    context 'invalid user input' do
      it 'repeats asking for a users selection if the previous selection was invalid' do
        stub_get_users
        stub_user_me_get
        stub_server_user_get
        stub_get_other_user
        stub_create_secret

        expect(run_cli('secret', 'add') do |i|
          i.puts 'test'
          i.puts 'test'
          i.puts 'Y'
          i.puts '3'
          i.puts '1'
          i.puts 'n'
        end.success?).to be true
      end
    end
  end
end
