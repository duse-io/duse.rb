require 'duse/cli/secret'
require 'fakefs/spec_helpers'

describe Duse::CLI::Secret do
  include FakeFS::SpecHelpers

  before :each do
    FileUtils.mkdir_p(File.dirname(Duse::CLIConfig.config_file))
    open(Duse::CLI.config.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
  end

  it 'should be able to login successfully' do
    expect(run_cli('login') do |i|
      i.puts 'flower-pot'
      i.puts 'Passw0rd!'
    end.success?).to be true

    expect(File.read Duse::CLI.config.config_file).to eq(
      "---\nuri: https://example.com/\ntoken: token\n"
    )
  end

  it 'should handle logins correctly' do
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
