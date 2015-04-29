require 'webmock/rspec'
require 'json'

module MockAPI
  def stub_get_users
    payload = [{
      'id' => 1,
      'username' => 'server',
      'email' => 'server@localhost',
      'url' => 'https://example.com/users/1'
    }, {
      'id' => 2,
      'username' => 'flower-pot',
      'email' => 'flower-pot@example.org',
      'url' => 'https://example.com/users/2'
    }, {
      'id' => 3,
      'username' => 'adracus',
      'email' => 'adracus@example.org',
      'url' => 'https://example.com/users/3'
    }].to_json
    stub_request(:get, "https://example.com/users").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload, headers: {})
  end

  def stub_user_me_get
    payload = {
      'id' => 2,
      'username' => 'flower-pot',
      'email' => 'flower-pot@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/2'
    }.to_json

    stub_request(:get, "https://example.com/users/me").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_server_user_get
    payload = {
      'id' => 1,
      'username' => 'server',
      'email' => 'server@localhost',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/1'
    }.to_json

    stub_request(:get, "https://example.com/users/server").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_get_other_user
    payload = {
      'id' => 3,
      'username' => 'adracus',
      'email' => 'adracus@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/3'
    }.to_json
    stub_request(:get, "https://example.com/users/3").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload, headers: {})
  end

  def stub_get_secrets
    payload = [{
      'id' => 1,
      'title' => 'test',
      'url' => 'http://example.com/secrets/1'
    }].to_json
    stub_request(:get, "https://example.com/secrets").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_secret_get
    payload = {
      'id' => 1,
      'title' => 'test',
      'cipher_text' => "DZTJUbyBLTtJ2TFETHfbvw==\n",
      'shares' => [
        "XY0lnt5J0ngppNqD6O2ZWSb2GJc44p+JPCvbGPggaOkzkEFWjwoBsT8sgtGp\nWJA34ve9CfUUSJOZA0UwjKpECLQWOSm5ioxs2PEP/BwBUhAjro++9Xh2PYX6\nqzJnyYZOUBGI20mUNaM3yFR4qJnuOm4CmGKZw0qLLBAJyR5MjFwjc0nZjWDo\nQ77UHQ5OieCPNo8sRv3fBqYtYSXd/Fl6iywkvWAFrjgDcAhc6VKaQm1NE/T0\nWY1Bz5uGRfDt1ADzIt4U9Ho4pqv8aI2piUKhysJOo/Sf3ykg3gj605/kt1+k\nRsNN3a/bTAvsHnmzqshpzHguiiXcT2fgNeqHwr2gtw==\n",
        "QUEyuQxtCJBzpErkFdTBEicLpfr2sNZDnOLNMy5bRw2WcbqW6wzlwbkhOJ8u\n3O7FgGJUHhjKishPbXQPMjlLin2fL2wZpKmHDrgWCWfcoQ/OmO1tNbIkrbjZ\nhIyb86ueffEYt53GzKo9QDNQstF4VuJgciASVwksEO6FiwOWKp5ZvYnB+1zm\nFxWlpy38ODCgNsw4WLJtH6FAPTuX8BKbp+ZNs+GAp9A1Ao6GeUCWsIdCvXbN\nxje8ghebdLWvNNxF0fIPS42ZGGoG5J/VNdTBvu1W0QPvF4YOEmIeAXu5yXjU\n8JVzE7HNBJuevGpiulwobh+X95dgAYLLO3grJFNAGA==\n"
      ],
      'users' => [{
        'id' => 1,
        'username' => 'server',
        'email' => 'server@localhost',
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n",
        'url' => 'https://example.com/users/1'
      }, {
        'id' => 2,
        'username' => 'flower-pot',
        'email' => 'flower-pot@example.org',
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n",
        'url' => 'https://example.com/users/2'
      }],
      'url' => 'http://example.com/secrets/1'
    }.to_json

    stub_request(:get, "https://example.com/secrets/1").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_secret_delete
    stub_request(:delete, "https://example.com/secrets/1").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 204, body: "", headers: {})
  end

  def stub_create_secret
    payload = {
      'id' => 1,
      'title' => 'test',
      'users' => [{
        'id' => 1,
        'username' => 'server',
        'email' => 'server@localhost',
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n",
        'url' => 'https://example.com/users/1'
      }, {
        'id' => 2,
        'username' => 'flower-pot',
        'email' => 'flower-pot@example.org',
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
        'url' => 'https://example.com/users/2'
      }],
      'parts' => [[
        "dVp1FjdfbtGF371TABXSeJ9HNPm9uBYQGaSyBasXqFmnGQqCiZEF0UWPTaG9\nwM7KV1GPwbj/GowwPT0Q8mv9wZ/bCQ2NlQ8Usuiol2SWtGtAYU74C6jzbQH6\ni1gq55I/T8JMiZmebnlnh/7rr9hOh9lQcjylbH792stsntxwlu4=\n",
        "ZfP2yMLwNOe2yBU6UDrOjnE9OX0SX/xbfG+s4mjji6cvfmN7uuyoWTPa3tb8\n6/hNENIpRa/RPGTzeh/jeU7wYIiG3HGb6Z221S6ikEXYNtRqL0plOq8nY+kh\nxV+3PlBXhNNdUvtUTf3D5dtfWdxL2tuPJUnTnWyoNSDko+NXlHM=\n"
      ]],
      'url' => 'http://example.com/secrets/1'
    }.to_json
    stub_request(:post, "https://example.com/secrets").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 201, body: payload, headers: {})
  end
end

