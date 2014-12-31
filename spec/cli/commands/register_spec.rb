describe Duse::CLI::Register do
  include FakeFS::SpecHelpers

  before :each do
    FileUtils.mkdir_p(File.dirname(Duse::CLIConfig.config_file))
    open(Duse::CLI.config.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
    public_key_file = File.expand_path('~/.ssh/id_rsa.pem')
    FileUtils.mkdir_p(File.dirname(public_key_file))
    open(public_key_file, 'w') do |f|
      f.puts "-----BEGIN RSA PUBLIC KEY-----\n"
      f.puts "MIGJAoGBAK1oA5FmkUnTfsA3UOubzxMtjJnL68vJVmv1co98xQX8oIcSxPWAl9Bg\n"
      f.puts "VEju3+AeMvdWi4ozXTrvV/+Dyzm3WFYcXpg69oVN3fINcCR/zrHmOs8Gsgfozczl\n"
      f.puts "Y7DCrBb1pEXbYIXOUGgKhXgZC3gqFHOqsbaRElQuwG5P1OIcIoQ/AgMBAAE=\n"
      f.puts "-----END RSA PUBLIC KEY-----"
    end
  end

  it 'should be able to register successfully' do
    expect(run_cli('register') do |i|
      i.puts 'flower-pot'
      i.puts 'Passw0rd!'
      i.puts 'Passw0rd!'
    end.success?).to be true
  end
end
