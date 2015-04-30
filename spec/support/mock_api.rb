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
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n",
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
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/1'
    }.to_json

    stub_request(:get, "https://example.com/users/server").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  # private key for documentation is: "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA0Y1b9awjW0nshQXk64uO1v+GYliBH8ogu6QjQDn0eoLIfcOi\nbrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMBH3ITTmNkhzOkdRXLJGJXXv3OCYR0\nJ+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0EmE4IDFq22Aar7MxSjrLk17LX9mTif\ndzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ35b8c2Zyehx6jxHk+jt5CguMC9Vq\nSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjchJEnrpHLeJxGMEThPoGqgQWiG5BB\nYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS5QIDAQABAoIBAQC3pXYRMOHvkDKr\nRcYgs7bkLx47tCq9jGvxZmDKWcArWdCRf1EsTxefXqGumbpu73wcMDk7JcBXevc/\nuw19R4zVXSkUSsEASD75qbbVVSYTBsV5y83sY6MEN2dNmcEMHeS7waEY4v/Ij0qe\n0akCFFdlQ0ynpGdcwNbTJmRm7A4ZOrLMoVTJaI/enRJcQSEzBkQ/oHpMlcDBoFJq\nIB61tfm5JD6IPM2BKlXvSOpV8ItPpJYG4PJxUDT7YEhrXy0vGHKyjaKoE04EdLvI\nvfEkP67if9BTR0tMP+dxaeZ8c9ydGCHC9p1rDJMdpGoS4gwBLueEkDxNEchtrf5p\nM+fPan5lAoGBAPR6YLODhK6YIl6M1EMxbXlytnwAwr5vJvMmRBiVyXLnXKoVFI8V\nHkPsjO6wUH8OjZjEflteoo7Co2pawvfUuPhtHPrWVpW8tAdIELGfazOnsdxvcIAJ\nTUB7tHSS/WeWEcsloCAOTb+6wjZdah9CDly95madbI1IYtz9s0Z/TPMXAoGBANtt\nmhAIxNs/8X9lDWbkbQRWdIr/sb6LCQcBN/Jc5mdz9Kp3sXu2Ag4aRsSPbbtu+XBY\nkl+aSIIYWlHJJE1kKKMDJ+cEpCdx8+kdhz/NIfAdbo3RsZ3cDy7ZM28iHNO4LVRX\ndu/VlBrm4CXCBdlug4+GhZK7on1YnPtrqldV7RdjAoGBALb6nUPejMEMdrTjnL8J\n0JEUjYZ0H03e7X0RR+hKu7L3fUCDdJa+zJ8z/itr5WOjZdFQR+5k/y/wd9TTR5es\nLCErsYQARl/eE7RbeLsowVixC4scEUyTKbG4pNCXb3hHNtwgNh+n9QMqac+8zP/G\nNe+t5jMpYiTAZ9ZVQAfkoZhTAoGAezIG7Hev5pT5Bph6tMkM+AF+P0gdyCgRcnBZ\ns+Y6qdytgkPfTuC6OKbCErugVTqSK2RfEfPyP7BijUaL7jOMqTEtZwPxEgBle/1L\nISQPqNstZcxUl5ekop3pxbx2SNw//vl4WmEkXRJAyJItbI0iqiNRvTdBnHRy9qnV\nImGo0pcCgYEA5SJk+Fx/9bJXyKEJIp/Q+Zjq5Oc/4Th9b8ydSBCeksoz9qF+5pWq\nWpDXCa1fdLUxXK+cG39VxF3w2pok5NASeTgF+0myUofc8z/+K/qCDCn8wbojCZpi\nJwB1XlU0M+ZV9emAI1L1DGtoz7i8LT0uG8U5wWFZNljI3GXhfOYpWD4=\n-----END RSA PRIVATE KEY-----\n"
  def stub_get_other_user
    payload = {
      'id' => 3,
      'username' => 'adracus',
      'email' => 'adracus@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Y1b9awjW0nshQXk64uO\n1v+GYliBH8ogu6QjQDn0eoLIfcOibrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMB\nH3ITTmNkhzOkdRXLJGJXXv3OCYR0J+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0Em\nE4IDFq22Aar7MxSjrLk17LX9mTifdzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ\n35b8c2Zyehx6jxHk+jt5CguMC9VqSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjc\nhJEnrpHLeJxGMEThPoGqgQWiG5BBYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS\n5QIDAQAB\n-----END PUBLIC KEY-----\n",
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
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n",
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

    stub_request(:post, "https://example.com/secrets").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 201, body: payload, headers: {})
  end
end

