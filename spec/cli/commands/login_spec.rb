describe 'duse login', :fs => :fake do
  before :each do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    open(Duse::CLIConfig.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
  end

  context 'correct credentials' do
    it 'writes the auth token in the config file' do
      open(File.join(Duse::CLIConfig.config_dir, 'flower-pot'), 'w') do |f|
        f.puts user_private_key.to_s
      end
      stub_user_me_get
      stub_request(:post, "https://example.com/users/token").
        with(body: {username: "flower-pot", password: "Passw0rd!"}.to_json,
             headers: {'Accept'=>'application/vnd.duse.1+json', 'Content-Type'=>'application/json'}).
        to_return(status: 201, body: { api_token: 'token' }.to_json, headers: {})

      expect(run_cli('login') do |i|
        i.puts 'flower-pot'
        i.puts 'Passw0rd!'
      end.success?).to be true

      expect(File.read Duse::CLIConfig.config_file).to eq(
        "---\nuri: https://example.com/\ntoken: token\n"
      )
    end
  end

  context 'incorrect credentials' do
    it 'errors with a message' do
      stub_request(:post, "https://example.com/users/token").
        with(body: {username: "flower-pot", password: "wrong password"}.to_json,
             headers: {'Accept'=>'application/vnd.duse.1+json', 'Content-Type'=>'application/json'}).
        to_return(status: 401, body: "", headers: {})

      expect(run_cli('login') do |i|
        i.puts 'flower-pot'
        i.puts 'wrong password'
      end.err).to eq(
        "Wrong username or password!\n"
      )

      expect(File.read Duse::CLIConfig.config_file).to eq(
        "---\nuri: https://example.com/\n"
      )
    end
  end
end
