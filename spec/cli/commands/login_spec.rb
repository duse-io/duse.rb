require 'duse/cli/secret'
require 'fakefs/spec_helpers'

describe Duse::CLI::Secret do
  include FakeFS::SpecHelpers

  before :each do
    @dir = File.dirname(Duse::CLIConfig.config_file)
    FileUtils.mkdir_p @dir
    open(Duse::CLI.config.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
  end

  after :each do
    FileUtils.rm_rf @dir
  end

  it 'should be able to login successfully' do
    stub_request(:post, "https://example.com/users/token").
      with(body: {username: "flower-pot", password: "Passw0rd!"}.to_json,
           headers: {'Accept'=>'application/vnd.duse.1+json', 'Content-Type'=>'application/json'}).
      to_return(status: 201, body: { api_token: 'token' }.to_json, headers: {})

    expect(run_cli('login') do |i|
      i.puts 'flower-pot'
      i.puts 'Passw0rd!'
    end.success?).to be true

    expect(File.read Duse::CLI.config.config_file).to eq(
      "---\nuri: https://example.com/\ntoken: token\n"
    )
  end

  it 'should handle logins correctly' do
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

    expect(File.read Duse::CLI.config.config_file).to eq(
      "---\nuri: https://example.com/\n"
    )
  end
end
