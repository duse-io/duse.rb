describe 'duse login' do
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
        f.puts "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
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
