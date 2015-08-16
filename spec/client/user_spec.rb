RSpec.describe Duse::Client::User do
  before :each do
    Duse.config = Duse::CLIConfig.new({ 'uri' => 'https://example.com/' })
  end

  def stub_create_user
    payload = {
      'id' => 2,
      'username' => 'flower-pot',
      'email' => 'flower-pot@example.org',
      'public_key' => user_public_key.to_s,
      'url' => 'https://example.com/users/2'
    }.to_json

    stub_request(:post, "https://example.com/users").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 201, body: payload, headers: {})
  end

  describe '.all' do
    it 'returns an array of users' do
      stub_get_users
      users = Duse::User.all

      expect(users.length).to eq 3
      expect(users.class).to be Array
      users.each do |user|
        expect(user.class).to be Duse::Client::User
      end
    end
  end

  describe '.create' do
    it 'creates correct user entity from json create response' do
      stub_create_user

      user = Duse::User.create(
        username: 'flower-pot',
        email:    'flower-pot@example.org',
        password: 'Passw0rd!',
        password_confirmation: 'Passw0rd!',
        public_key: user_public_key.to_s
      )

      expect(user.username).to eq 'flower-pot'
      expect(user.email).to eq 'flower-pot@example.org'
      expect(user.public_key.to_s).to eq user_public_key.to_s
    end
  end

  describe '.find' do
    context 'own user' do
      it 'creates the correct entity when requesting own user' do
        stub_user_me_get
        public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n")

        user = Duse::User.find 'me'

        expect(user.username).to eq 'flower-pot'
        expect(user.email).to eq 'flower-pot@example.org'
        expect(user.public_key.to_s).to eq public_key.to_s
      end
    end

    context 'server user' do
      it 'creates the correct entity when requesting the server user' do
        stub_server_user_get
        public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n")

        user = Duse::User.find 'server'

        expect(user.username).to eq 'server'
        expect(user.email).to eq 'server@localhost'
        expect(user.public_key.to_s).to eq public_key.to_s
      end
    end

    context 'any user' do
      it 'creates the correct entity when requesting a specific user' do
        stub_get_other_user
        public_key = OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Y1b9awjW0nshQXk64uO\n1v+GYliBH8ogu6QjQDn0eoLIfcOibrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMB\nH3ITTmNkhzOkdRXLJGJXXv3OCYR0J+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0Em\nE4IDFq22Aar7MxSjrLk17LX9mTifdzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ\n35b8c2Zyehx6jxHk+jt5CguMC9VqSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjc\nhJEnrpHLeJxGMEThPoGqgQWiG5BBYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS\n5QIDAQAB\n-----END PUBLIC KEY-----\n")

        user = Duse::User.find 3

        expect(user.username).to eq 'adracus'
        expect(user.email).to eq 'adracus@example.org'
        expect(user.public_key.to_s).to eq public_key.to_s
      end
    end
  end

  it 'reloads an entity when necessary' do
    stub_get_users
    stub_get_other_user
    users = Duse::User.all
    user  = users.last

    expect(users.length).to eq 3
    expect(user.attributes['public_key']).to be nil
    expect(user.username).to eq 'adracus'
    expect(user.email).to eq 'adracus@example.org'
    expect(user.public_key.to_s).to eq OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Y1b9awjW0nshQXk64uO\n1v+GYliBH8ogu6QjQDn0eoLIfcOibrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMB\nH3ITTmNkhzOkdRXLJGJXXv3OCYR0J+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0Em\nE4IDFq22Aar7MxSjrLk17LX9mTifdzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ\n35b8c2Zyehx6jxHk+jt5CguMC9VqSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjc\nhJEnrpHLeJxGMEThPoGqgQWiG5BBYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS\n5QIDAQAB\n-----END PUBLIC KEY-----\n").to_s
  end
end
