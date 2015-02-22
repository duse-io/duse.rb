describe Duse::CLI::Register do
  include FakeFS::SpecHelpers

  before :each do
    @dir = File.dirname(Duse::CLIConfig.config_file)
    FileUtils.mkdir_p @dir
    open(Duse::CLI.config.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
    end
    @public_key_file = File.expand_path('~/.ssh/id_rsa.pub')
    FileUtils.mkdir_p(File.dirname(@public_key_file))
    open(@public_key_file, 'w') do |f|
      f.puts "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCtaAORZpFJ037AN1Drm88TLYyZy+vLyVZr9XKPfMUF/KCHEsT1gJfQYFRI7t/gHjL3VouKM10671f/g8s5t1hWHF6YOvaFTd3yDXAkf86x5jrPBrIH6M3M5WOwwqwW9aRF22CFzlBoCoV4GQt4KhRzqrG2kRJULsBuT9TiHCKEPw== RSA-1024"
    end
  end

  after :each do
    FileUtils.rm_rf @dir
    FileUtils.rm_rf File.dirname(@public_key_file)
  end

  it 'should be able to register successfully' do
    expect(run_cli('register') do |i|
      i.puts 'flower-pot'
      i.puts 'fbranczyk@gmail.com'
      i.puts 'Passw0rd!'
      i.puts 'Passw0rd!'
      i.puts '1'
    end.success?).to be true
  end
end
