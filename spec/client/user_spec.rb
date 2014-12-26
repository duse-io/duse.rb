describe Duse::Client::User do
  it 'creates correct entity instances from user array' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'

    users = Duse::User.all

    expect(users.length).to eq 3
    expect(users.class).to be Array
    users.each do |user|
      expect(user.class).to be Duse::Client::User
    end
  end
  
  it 'creates correct user entity from json create response' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n"

    user = Duse::User.create(
      'username' => 'flower-pot',
      'password' => 'Passw0rd!',
      'password_confirmation' => 'Passw0rd!',
      'public_key' => public_key
    )

    expect(user.username).to eq 'flower-pot'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting own user' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n"
    
    user = Duse::User.find 'me'

    expect(user.username).to eq 'flower-pot'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting server user' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n"
    
    user = Duse::User.find 'server'

    expect(user.username).to eq 'server'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting a specific user' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n"
    
    user = Duse::User.find 'server'

    expect(user.username).to eq 'server'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should create the correct entity when requesting a specific user' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'
    public_key = "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n"
    
    user = Duse::User.find 3

    expect(user.username).to eq 'adracus'
    expect(user.public_key.to_s).to eq public_key
  end

  it 'should reload the entity when necessary' do
    Duse.session = Duse::Client::Session.new uri: 'https://example.com/'

    users = Duse::User.all
    user  = users.last

    expect(users.length).to eq 3
    expect(user.attributes['public_key']).to be nil
    expect(user.username).to eq 'adracus'
    expect(user.public_key.to_s).to eq "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n"
  end
end
