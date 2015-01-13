describe Duse::Client::Secret do
  before :each do
    Duse.uri = 'https://example.com/'
  end

  it 'should load a users secrets without shares' do
    secrets = Duse::Secret.all

    expect(secrets.length).to eq 1
    expect(secrets.class).to be Array
    secrets.each do |secret|
      expect(secret.class).to be Duse::Client::Secret
    end
    secret = secrets.first
    expect(secret.title).to eq 'test'
    expect(secret.attributes['shares']).to eq nil
  end

  it 'should load a single secret with shares' do
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"

    secret = Duse::Secret.find 1

    expect(secret.title).to eq 'test'
    expect(secret.decrypt(private_key)).to eq 'test'
  end

  it 'should raise an exception when trying to get a non existant secret' do
    expect { Duse::Secret.find 2 }.to raise_error Duse::Client::NotFound
  end

  it 'should be able to delete an existing secret' do
    Duse::Secret.delete 1
  end

  it 'should be able to delete a previously retrieved secret' do
    secret = Duse::Secret.find 1
    secret.delete
  end

  it 'correctly build a secret after creating it' do
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"

    secret = Duse::Secret.create({
      title: 'test',
      shares: [[
        {user_id: 'server', content: "T6BKRp0U41zRRZ2NSRPwpJW7NjsSZaJ1eSSdtYNjchscXb5UIEqzSr/+B6Zy\nJ8JUA9CPrad+Z6s1CNNPGN6sJKtdAtzk+zJr5vTeg/4Aw42799A8cFPw/fE9\nd5K+IIYjn4Yxtypcv0I2j+dYsgDvN+mhosZ21cdibfX5PyyibuA=\n", signature: "XBMWwpKyO5K+S1dimX/7aZ4oX7dW5SDlf4KaagYUBoVm7ii7jX9jfLKWqrRL\nj2f85JYMSUQ3UoXVWT1LDWXXZIs3KO02xlvA+oflmx5ZSGx57TDvuYpusEBu\n/LNSpNj6ooROXTm+Xq+AvQfmt0bjQZCg/PSOt8Qx11q5JLmhL38=\n"},
        {user_id: 'me', content: "XMcasmkkD0eOB52ilT3sGUOy9ehHpsuIFnbmErKLsTq0PExcvSuGT6RwMKjE\nM3rS7Lu2nHgWm0IPSzi5Vd8ieJTgyayYgT9VCOOnKGqfAMmCpV0WrHpfNwLu\nUgH7VC3Wfk1F+6yzWAFOoYXBDUuIRRau4uswCpedp1pe3csmO+I=\n", signature: "dAhhcWeebiE5E9jfhexu+/zem1emWG2vBQed06f4CJJ24xrWDwUgX9kggHka\nsOWgu/RnCN/qzIuN8XCPgh2I1zQegd9d5FdAHUqXJRgpT2bvmAYPZ6DM6UYs\nB8OJ7+QgQy9EahTfhfbrSKuqtnX9103ftTZtiGagzFdYi5ylMNM=\n"}
      ]]
    })

    expect(secret.title).to eq 'test'
    expect(secret.decrypt(private_key)).to eq 'test'
  end

  it 'should be able to marshall a secret correctly' do
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
    current_user = OpenStruct.new public_key: OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n")
    server_user = OpenStruct.new public_key: OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n")
    secret_text = "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
    secret = Duse::Client::Secret.new title: 'test', secret_text: secret_text, users: [current_user, server_user]
    Duse::Client::SecretMarshaller.new(secret, private_key).to_h
  end

  it 'should be able to handle more than self and server as users' do
    private_key = OpenSSL::PKey::RSA.new "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
    current_user = OpenStruct.new public_key: OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n")
    server_user  = OpenStruct.new public_key: OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n")
    other_user   = OpenStruct.new public_key: OpenSSL::PKey::RSA.new("-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n")
    secret_text  = "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"
    secret = Duse::Client::Secret.new title: 'test', secret_text: secret_text, users: [other_user, current_user, server_user]

    Duse::Client::SecretMarshaller.new(secret, private_key).to_h
  end
end
