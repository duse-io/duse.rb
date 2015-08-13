require 'webmock/rspec'
require 'json'
require 'uri'

module MockAPI
  METHOD_STATUS_DEFAULT = { get: 200, put: 200, patch: 200, post: 201, delete: 204 }

  class RequestStub
    def initialize(http_method, route)
      @http_method = http_method
      @url = URI.join('https://example.com/', route)
      @status = METHOD_STATUS_DEFAULT[http_method]
      @request_headers = { 'Accept'=>'application/vnd.duse.1+json' }
      @response_headers = {}
      @body = nil
    end

    def body(body)
      @body = body
      @body = @body.to_json if @body.is_a?(Hash) || @body.is_a?(Array)
      self
    end

    def activate
      WebMock.stub_request(@http_method, @url).
        with(headers: @request_headers).
        to_return(status: @status, body: @body, headers: @response_headers)
    end
  end

  [:get, :put, :patch, :post, :delete].each do |http_method|
    define_method "stub_#{http_method.to_s}" do |route|
      RequestStub.new(http_method, route)
    end
  end

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
    }]
    stub_get('/users').body(payload).activate
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
    }

    stub_get("/users/#{id}").body(payload).activate
  end

  def stub_user_get1(id = 1)
    payload = {
      'id' => 1,
      'username' => 'server',
      'email' => 'server@localhost',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvyvyAf7lnVx9eQcAS7JL\nYRHrqJJe51rAdanaUiiy8eek2Iyh6JG551EK7x4n9/Y7r0fW2sNmy+Bp3FpL8E/p\ncxutggTWCnUQUvXmEEm5qZ1KOIIlEQNp5glToAenJ7pxotJsTMlVw4tizsKScenc\n8w+02wpcmWuzWKjoY/G5KV33UDz/LxVo1RJdJp94JiL/OinIl+uk+Vf7VZj/E8g/\n7DyXIuiBosVpj9E9T4kpxs3/7RmUfDzUisVq0UvgflRjvP1V+1KdpNnjVB+H08mb\nSVO6yf2YOcrPDRa3pgz7PIr225QJ+HmVjPTg5VAy7rUxhCK+q+HNd2oz35zA70SO\npQIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/1'
    }

    stub_get("/users/#{id}").body(payload).activate
  end

  def stub_server_user_get
    stub_user_get1('server')
  end

  def stub_get_other_user
    payload = {
      'id' => 3,
      'username' => 'adracus',
      'email' => 'adracus@example.org',
      'public_key' => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0Y1b9awjW0nshQXk64uO\n1v+GYliBH8ogu6QjQDn0eoLIfcOibrotbhJuSS0G46yOhboOCZQWrwyqi4MYtTMB\nH3ITTmNkhzOkdRXLJGJXXv3OCYR0J+PdCXbrtfYkvqOgyJE4RAR6YBEO/XcQk0Em\nE4IDFq22Aar7MxSjrLk17LX9mTifdzg1xdxX5myX4NrXGVWTWKeS5klLWCe9AigQ\n35b8c2Zyehx6jxHk+jt5CguMC9VqSyJobKdu926W4k2AgzWRdZh0EvCg2wWjlYjc\nhJEnrpHLeJxGMEThPoGqgQWiG5BBYIl9kx1vg1QZmS2biS6djGpGIn8l8PN30+QS\n5QIDAQAB\n-----END PUBLIC KEY-----\n",
      'url' => 'https://example.com/users/3'
    }

    stub_get('/users/3').body(payload).activate
  end

  def stub_get_secrets
    payload = [{
      'id' => 1,
      'title' => 'test',
      'url' => 'http://example.com/secrets/1'
    }]
    stub_get('/secrets').body(payload).activate
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
    }

    stub_get('/secrets/2').body(payload).activate
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
    }

    stub_get('/secrets/1').body(payload).activate
  end

  def stub_secret_delete
    stub_delete('/secrets/1').activate
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

    stub_post('/secrets').body(payload).activate
  end
end

