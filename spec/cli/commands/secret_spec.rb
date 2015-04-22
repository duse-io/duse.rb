RSpec.describe 'duse secret' do
  before :each do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    open(Duse::CLIConfig.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
      f.puts 'token: token'
    end
    open(Duse::CLIConfig.new.private_key_file_for(OpenStruct.new(username: 'flower-pot')), 'w') do |f|
      f.puts "-----BEGIN RSA PRIVATE KEY-----"
      f.puts "MIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ"
      f.puts "zbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS"
      f.puts "xrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB"
      f.puts "AoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS"
      f.puts "lH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv"
      f.puts "va+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ"
      f.puts "/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k"
      f.puts "pKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O"
      f.puts "cY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+"
      f.puts "GyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i"
      f.puts "urGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK"
      f.puts "+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7"
      f.puts "LZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE"
      f.puts "-----END RSA PRIVATE KEY-----"
    end
  end

  describe 'get' do
    context 'provide secret id from the call' do
      it 'takes the secrets id from the cli call and does not ask for it' do
        stub_secret_get
        stub_user_me_get
        stub_server_user_get
        expect(run_cli('secret', 'get', '1').out).to eq(
          "\nName:   test\nSecret: test\nAccess: server, flower-pot\n"
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
        stub_secret_get
        stub_user_me_get
        stub_server_user_get
        expect(run_cli('secret', 'get') { |i| i.puts('1') }.out).to eq(
          "Secret to retrieve: \nName:   test\nSecret: test\nAccess: server, flower-pot\n"
        )
      end
    end
  end

  describe 'list' do
    it 'lists secrets' do
      stub_get_secrets

      expect(run_cli('secret', 'list').out).to eq(
        "1: test\n"
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
          i.puts 'Y'
          i.puts '1'
        end.success?).to be true
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
        end.success?).to be true
      end
    end
  end
end
