require 'webmock/rspec'
require 'json'
require 'uri'
require 'support/key_helper'

module MockAPI
  METHOD_STATUS_DEFAULT = { get: 200, put: 200, patch: 200, post: 201, delete: 204 }
  include KeyHelper

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

  def secret_hash
    {
      'id' => 1,
      'title' => 'test',
      'cipher_text' => "oMmo5ptscZJzzgTMkTQ63A==\n",
      'shares' => [
        {
          'last_edited_by_id' => 2,
          "content" => "CyNrNgp0ywDymkLkkU2kEU3oTZM65CzvuX9qbDOu0Yee4iAVI7+tIPXzaH/T\na47Lqq59eoQimzPJJYW6FGSkG7DRVZ5coZRIgmt+1nPAyCdTYEcJ9Aoj+9Ua\nE0SC5irgQatVN0LFh4M+mbrlkwhYpSpRh/WJvC2TWEDuh4koKcJ0hxyrvBxM\n/LbE5J3GlIm7U0fnoeGIcGYvJSqQD4N+6LmrWJFrPDwp2NhVGCGEDJvErDKC\nd0XiPu9WXr3YCZ3sgsaxJiqNicdzbfnLbaqP9Kq0y2Do7zU1tQEN0OOiTh1y\nfLLU0hDv1zGUSIzT/Z+yddTguvmd4LqxrGTsPCFP7A==\n",
          "signature" => "OGZgZ8nClakhxnt1LAh4iGNmXnB9hU44FtDrZSaVAvRLyGcFYdbxx1yueUxP\nLLY6K9pB19DqxowtOMdkBdVtss64+FKV87Wuqx2c+c6+l6VzSwTRdsezapiS\nunlY42v5io/lIQD9g+leMzJyw1tK4q3cixY9jsk5uXLR5opbOovBzweNIk1W\n7MXz0YYJgf/tTePqqcLFCV4i3JhT9zzCCAIb019mVpmqvUoouRFBuIet5cNR\nj4/wZqEiCyrd87Q+HG4Ssyh9UNKHCeC8zdhb67nfQKcRa8rNbnluLM4/HsIa\nBvmp9d0VtIYuH3ri+IYMQECo7ediDbkvZkqzjUl/kA==\n"
        },
        {
          'last_edited_by_id' => 2,
          "content" => "aOmkxffDVAxBmj7ZRfX6wEepaBKWlFzipBg3PdDtlOe45tepmMxY/juFECkw\nJODnq0knfcoIXD2ObVv9gzToAtZy+eTkgElmpxebrh3bH9iB1kDkLMq1z7C+\n/5HmBj8sJ59u6YFcyRGDrmL+yY+meeBGwJdH5lL1cOVMbe6lxbvItnSIQXpi\n6KQM5YczMBzd2jYUAJpGk22S2p4j+5ElKB7n9aR/VRPGaB+nnA5CJSTGSfrW\nDm4xjfzYBOgFNFpAF4+Yjw35+okrdSQoF16+y8+KeTdN/Uo/Jm+aQh9Q2tk4\nSjRnhJjY4ZqO0WMtML3BBQhbwXcXAFl0sxZF1zzB4Q==\n",
          "signature" => "Nv9sNIDypa0b4f7m4Bcf3bulikN487VbGizGBlDkfetXNCP0zrL/LtUfGMv6\n158HoX68nBPVX+0o1wSkjKoD4Qm79E3F4ftPLrHcsErvZr8rCUluRpoBsK/O\nP3ZOstyjEMjbkj2eaqmZkykhVIR55JtXzIM3YCo4UwjgtgzCyK5Ym8of3xzi\npVfoy4ZYVQnk7ec5u5nQUMpI8gixPH1WfM94bxZyw8bICr8r6kw5TkqEvW5U\nhpFkYdRXj8Fav1gHq3GiGmUhxd59Q/79optz3nWl/v/jDnVbEoAEtDltGS1B\n+Ijtoq3SfNkPY3DyhUxB5MSkMH5axJdcyFuU389j7A==\n"
        }
      ],
      'users' => [{
        'id' => 1,
        'username' => 'server',
        'email' => 'server@localhost',
        'public_key' => server_public_key.to_s,
        'url' => 'https://example.com/users/1'
      }, {
        'id' => 2,
        'username' => 'flower-pot',
        'email' => 'flower-pot@example.org',
        'public_key' => user_public_key.to_s,
        'url' => 'https://example.com/users/2'
      }],
      'url' => 'http://example.com/secrets/1'
    }
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
      'public_key' => user_public_key.to_s,
      'url' => 'https://example.com/users/2'
    }

    stub_get("/users/#{id}").body(payload).activate
  end

  def stub_user_get1(id = 1)
    payload = {
      'id' => 1,
      'username' => 'server',
      'email' => 'server@localhost',
      'public_key' => server_public_key.to_s,
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
      'public_key' => other_public_key.to_s,
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
    payload = secret_hash
    payload['shares'][0]['signature'] = 'blabla'
    payload['shares'][1]['signature'] = 'blabla'

    stub_get('/secrets/2').body(payload).activate
  end

  def stub_secret_get
    stub_get('/secrets/1').body(secret_hash).activate
  end

  def stub_secret_delete
    stub_delete('/secrets/1').activate
  end

  def stub_create_secret
    stub_post('/secrets').body(secret_hash).activate
  end
end

