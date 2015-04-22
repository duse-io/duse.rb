RSpec.describe 'duse account' do
  before :each do
    FileUtils.mkdir_p Duse::CLIConfig.config_dir
    open(Duse::CLIConfig.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
      f.puts 'token: token'
    end
  end

  it 'prints info about its subcommands' do
    expect(run_cli('account').success?).to be true
    expect(last_run.out).to include('duse account COMMAND')
  end

  describe 'confirm' do
  end

  describe 'resend-confirmation' do
  end

  describe 'info' do
    context 'if logged in' do
      it 'prints the current users account information' do
        stub_user_me_get

        expect(run_cli('account', 'info').success?).to be true
        expect(last_run.out).to eq [
          "\nUsername: flower-pot\n",
          "Email:    flower-pot@example.org\n"
        ].join
      end
    end
  end

  describe 'update' do
  end

  describe 'password' do
    it 'prints info about its subcommands' do
      expect(run_cli('account', 'password').success?).to be true
      expect(last_run.out).to include('duse account password COMMAND')
    end
  end
end
