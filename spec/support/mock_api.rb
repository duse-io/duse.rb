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
    stub_user_get2('me')
  end

  def stub_user_get2(id = 2)
    payload = {
      'id' => 2,
      'username' => 'flower-pot',
      'email' => 'flower-pot@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmMm3Ovh7gU0rLHK4NiHh\nWaYRrV9PH6XtHqV0GoiHH7awrjVkT1aZiS+nlBxckfuvuQjRXakVCZh18UdQadVQ\n7FLTWMZNoZ/uh41g4Iv17Wh1I3Fgqihdm83cSWvJ81qQCVGBaKeVitSa49zT/Mmo\noBvYFwulaqJjhqFc3862Rl3WowzGVqGf+OiYhFrBbnIqXijDmVKsbqkG5AILGo1n\nng06HIAvMqUcGMebgoju9SuKaR+C46KT0K5sPpNw/tNcDEZqZAd25QjAroGnpRHS\nI9hTEuPopPSyRqz/EVQfbhi0LbkdDW9S5ECw7GfFPFpRp2239fjl/9ybL6TkeZL7\nAwIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/2'
    }.to_json

    stub_request(:get, "https://example.com/users/#{id}").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_user_get1(id = 1)
    payload = {
        'id' => 1,
        'username' => 'server',
        'email' => 'server@localhost',
        'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n",
        'url' => 'https://example.com/users/1'
    }.to_json

    stub_request(:get, "https://example.com/users/#{id}").
        with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
        to_return(status: 200, body: payload)
  end

  def stub_server_user_get
    stub_user_get1('server')
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

  def stub_secret_get_broken_signature
    payload = {
      'id' => 2,
      'title' => 'test',
      'cipher_text' => "DZTJUbyBLTtJ2TFETHfbvw==\n",
      'shares' => [
        { 'last_edited_by_id' => 1, 'signature' => "blabla123", 'content' => "JmmvpdzT3umPfU8eFmCLY35GYTjHwjTjaUKT2wTUgyRojFnYbjO3l1gQF0gZ\nspBGK2rlb5q8Ak18XIl+eOsIDmjtPS4a+9Uk/hcCgHmAZ5u5TRHjtEE0X1Ih\nKkF8iXN/PomOW4WCFEseK0VeRTcPzQZ6CtMWjb0Cgr95KpiAqIoPMSlSU8JD\nXbcKsaKeAXspXgjpN+wxyiI+dQIrU+hYhErYOa28AIZkFgtqiP8ZcgiNXqbm\nS6n211M4NCaqD2inZ3dpbDS6MLAG737kSbL5puclArSuyp71Q1a25s5YTmeI\nCAf30zcV3RwPOWjYLfi+Pb8vskN3bxblS3nJxJ4WbQ==\n" },
        { 'last_edited_by_id' => 2, 'signature' => "blabla123", 'content' => "IkiK8njWLinkWku7B5dltlMiyOzjDU2N+/2J+ZAUADcfOzA2xlRi6XhKg8BY\n3g792iWyzPpKzj17FywQf4MDL2h12KtC6nvBenlmZx49hg6fIcHCuUoSflwJ\n4Mz5+Ud3N3KP3Zak1WGR4wjVmjkvkFj/KWqMaTMfkc3dTArO15/9ld+J5kfS\n1XjSa8T+NDPBuwdE2VOLiwyJVLTBQuvjRimZ5QgGPoTnD6CQ5jvohyiDHCob\noSbH/TfhVbKlv/ZkSCyVsaWmMUbGvNNxRGjJRPyNZ6R5y74U9UQlO60J/Cur\nXQlBqTRBPf7cZPl/bRgicPabc61S17u8jQU1U4BDxQ==\n" }
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

    stub_request(:get, "https://example.com/secrets/2").
      with(headers: {'Accept'=>'application/vnd.duse.1+json'}).
      to_return(status: 200, body: payload)
  end

  def stub_secret_get
    payload = {
      'id' => 1,
      'title' => 'test',
      'cipher_text' => "DZTJUbyBLTtJ2TFETHfbvw==\n",
      'shares' => [
        { 'last_edited_by_id' => 1, 'signature' => "mWecJ8ni+yVsRmN4rOfE+i36s0efYkJcazLTE9d57fX7sV4yRujMrbaYCpzi\n90puFKHJex25CjrHEhDmb8i8YMNIX96DBymbb2yvyCSsBQ1e8LLE3tXlQ7SM\nRr2Q5mkqoLWcfaNhszw6gLTXElASdtUdd0lmcMX9kKwNmOmdv6eZcWphI4Ti\nVBdylYnMrq3zb+9FOqB2ONl9Gn/HiKItxCZw2dcyGhrwAVrGFisxVHHrMfKt\nF90vwLkfRKfoz4aKgS4x4FC2fSI8xIA5K1hHENMrEviNeC0nCMt1DnafR7Cb\nEVoTamNU9jSgMNrJxsQTOgsblqPpfV/JgGTx3iEyTg==\n", 'content' => "JmmvpdzT3umPfU8eFmCLY35GYTjHwjTjaUKT2wTUgyRojFnYbjO3l1gQF0gZ\nspBGK2rlb5q8Ak18XIl+eOsIDmjtPS4a+9Uk/hcCgHmAZ5u5TRHjtEE0X1Ih\nKkF8iXN/PomOW4WCFEseK0VeRTcPzQZ6CtMWjb0Cgr95KpiAqIoPMSlSU8JD\nXbcKsaKeAXspXgjpN+wxyiI+dQIrU+hYhErYOa28AIZkFgtqiP8ZcgiNXqbm\nS6n211M4NCaqD2inZ3dpbDS6MLAG737kSbL5puclArSuyp71Q1a25s5YTmeI\nCAf30zcV3RwPOWjYLfi+Pb8vskN3bxblS3nJxJ4WbQ==\n" },
        { 'last_edited_by_id' => 2, 'signature' => "fMB7PImowpcNBdgdeVRJtSGXtd5krI1wI/a/VbKRgPV4LiRxzoeuFrkhBrFq\n7L7/sXCdRsu5LyJGgxC8P/mSihv64e1jy/uXX9+HkhKfE7KQeSZKOvfIh4Hj\n7mKaAIQvAaASf54MKQFl5WHuXyUXUYECNS5uBHSSeFIjbIsaUuTXSrrvabBK\nk4VjHjz6C5yZ8uCHTP3Wsh8kg6kUqJcWV0cUSAo4eUxhrRnn7lGUTUp+HtVl\n0iTSJGrDXh1qiz6xO0FipWNyJEtZwxm005t0QhsA2E9hGgGMS2kvEFFNtvG0\ncz0b1WBrkZHum+Ol0xRC/u8jVmkxu4/TEiy0mfMbPg==\n", 'content' => "IkiK8njWLinkWku7B5dltlMiyOzjDU2N+/2J+ZAUADcfOzA2xlRi6XhKg8BY\n3g792iWyzPpKzj17FywQf4MDL2h12KtC6nvBenlmZx49hg6fIcHCuUoSflwJ\n4Mz5+Ud3N3KP3Zak1WGR4wjVmjkvkFj/KWqMaTMfkc3dTArO15/9ld+J5kfS\n1XjSa8T+NDPBuwdE2VOLiwyJVLTBQuvjRimZ5QgGPoTnD6CQ5jvohyiDHCob\noSbH/TfhVbKlv/ZkSCyVsaWmMUbGvNNxRGjJRPyNZ6R5y74U9UQlO60J/Cur\nXQlBqTRBPf7cZPl/bRgicPabc61S17u8jQU1U4BDxQ==\n" }
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
        { 'last_edited_by_id' => 1, 'signature' => "mWecJ8ni+yVsRmN4rOfE+i36s0efYkJcazLTE9d57fX7sV4yRujMrbaYCpzi\n90puFKHJex25CjrHEhDmb8i8YMNIX96DBymbb2yvyCSsBQ1e8LLE3tXlQ7SM\nRr2Q5mkqoLWcfaNhszw6gLTXElASdtUdd0lmcMX9kKwNmOmdv6eZcWphI4Ti\nVBdylYnMrq3zb+9FOqB2ONl9Gn/HiKItxCZw2dcyGhrwAVrGFisxVHHrMfKt\nF90vwLkfRKfoz4aKgS4x4FC2fSI8xIA5K1hHENMrEviNeC0nCMt1DnafR7Cb\nEVoTamNU9jSgMNrJxsQTOgsblqPpfV/JgGTx3iEyTg==\n", 'content' => "JmmvpdzT3umPfU8eFmCLY35GYTjHwjTjaUKT2wTUgyRojFnYbjO3l1gQF0gZ\nspBGK2rlb5q8Ak18XIl+eOsIDmjtPS4a+9Uk/hcCgHmAZ5u5TRHjtEE0X1Ih\nKkF8iXN/PomOW4WCFEseK0VeRTcPzQZ6CtMWjb0Cgr95KpiAqIoPMSlSU8JD\nXbcKsaKeAXspXgjpN+wxyiI+dQIrU+hYhErYOa28AIZkFgtqiP8ZcgiNXqbm\nS6n211M4NCaqD2inZ3dpbDS6MLAG737kSbL5puclArSuyp71Q1a25s5YTmeI\nCAf30zcV3RwPOWjYLfi+Pb8vskN3bxblS3nJxJ4WbQ==\n" },
        { 'last_edited_by_id' => 2, 'signature' => "fMB7PImowpcNBdgdeVRJtSGXtd5krI1wI/a/VbKRgPV4LiRxzoeuFrkhBrFq\n7L7/sXCdRsu5LyJGgxC8P/mSihv64e1jy/uXX9+HkhKfE7KQeSZKOvfIh4Hj\n7mKaAIQvAaASf54MKQFl5WHuXyUXUYECNS5uBHSSeFIjbIsaUuTXSrrvabBK\nk4VjHjz6C5yZ8uCHTP3Wsh8kg6kUqJcWV0cUSAo4eUxhrRnn7lGUTUp+HtVl\n0iTSJGrDXh1qiz6xO0FipWNyJEtZwxm005t0QhsA2E9hGgGMS2kvEFFNtvG0\ncz0b1WBrkZHum+Ol0xRC/u8jVmkxu4/TEiy0mfMbPg==\n", 'content' => "IkiK8njWLinkWku7B5dltlMiyOzjDU2N+/2J+ZAUADcfOzA2xlRi6XhKg8BY\n3g792iWyzPpKzj17FywQf4MDL2h12KtC6nvBenlmZx49hg6fIcHCuUoSflwJ\n4Mz5+Ud3N3KP3Zak1WGR4wjVmjkvkFj/KWqMaTMfkc3dTArO15/9ld+J5kfS\n1XjSa8T+NDPBuwdE2VOLiwyJVLTBQuvjRimZ5QgGPoTnD6CQ5jvohyiDHCob\noSbH/TfhVbKlv/ZkSCyVsaWmMUbGvNNxRGjJRPyNZ6R5y74U9UQlO60J/Cur\nXQlBqTRBPf7cZPl/bRgicPabc61S17u8jQU1U4BDxQ==\n" }
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

