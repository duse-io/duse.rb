require 'duse/cli/secret'
require 'fakefs/spec_helpers'

describe Duse::CLI::Secret do
  include FakeFS::SpecHelpers

  before :each do
    FileUtils.mkdir_p(File.dirname(Duse::CLIConfig.config_file))
    open(Duse::CLI.config.config_file, 'w') do |f|
      f.puts '---'
      f.puts 'uri: https://example.com/'
      f.puts 'token: token'
    end
    FileUtils.mkdir_p(File.expand_path('~/.ssh'))
    open(File.expand_path('~/.ssh/id_rsa'), 'w') do |f|
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

  it 'should build the full command correctly' do
    expect(Duse::CLI::GetSecret.full_command).to eq 'secret get'
  end

  it 'should take the secret from the cli call' do
    expect(run_cli('secret', 'get', '1').out).to eq(
      "\nName:   test\nSecret: test\n"
    )
  end

  it 'should take the secret from a user input' do
    expect(run_cli('secret', 'get') { |i| i.puts('1') }.out).to eq(
      "Secret to retrieve: \nName:   test\nSecret: test\n"
    )
  end

  it 'should show an error message when getting not existant secrets' do
    expect(run_cli('secret', 'get', '2').err).to eq(
      "not found\n"
    )
  end

  it 'should list successfully' do
    expect(run_cli('secret', 'list').success?).to be true
  end

  it 'should delete successfully' do
    expect(run_cli('secret', 'delete', '1').success?).to be true
  end

  it 'should save successfully' do
    expect(run_cli('secret', 'save') do |i|
      i.puts 'test'
      i.puts 'test'
      i.puts 'n'
    end.success?).to be true
  end

  it 'should save successfully with multiple users' do
    expect(run_cli('secret', 'save') do |i|
      i.puts 'test'
      i.puts 'test'
      i.puts 'Y'
      i.puts '3'
    end.success?).to be true
  end
end
