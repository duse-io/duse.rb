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
      'cipher_text' => "0aqOigsWK04MhJ5EHgM49Q==\n",
      'shares' => [
        { 'last_edited_by_id' => 2, 'signature' => "dPMQbO9UzYFS4hY0U5iLjjVFTeGvDJemuEYVog6zClbLMbZG8pSaQ2MzNI1I\n0UsZJNXlyHP6NR/kTp0mpCmndrnA+c8c7UDotSE1BnMqizscZiBcTTlBn9IS\ncQsKLNsV50FDLqZnsLOuB0lvQnnUN4GrxmW38Vi/emva2voK+WQM3GybrFyd\nb2p5c9DN4abYpjASxg9IilkmnfYLfcs7LXgmtlJOl/dg7CybcaPrE+lOZn7F\nRLIfLh601cP3XyGe5WYHBMJXtJHYzczRlU/rJ98BosfqewHDjYRAHtt7IcVA\nWKseYK5TpBZLIbEK2ZcQLo65huyuKh6z4OReqjCvpQ==\n", 'content' => "NQSRqhjkHyUyT00YDgQ6WayC0EwtdytQ/iZAUdc6mnXKNQc74hae3VIJqjUf\nNkq1Qus/dS7a5DMsKa+2F74p1UF3YbswNnZ7fc2VH+iz6hIdYbgCu5bmAuVF\nXFpXk7Nw9n4Cpvjg2x5jxBQ0S1BnYY8J+EBluzichoqub4EVl5yxTWipqiaZ\nKwR1gEEKi3h5w2uljOib62gFdxUnXLtMjDlIXJjN6Kl9idCiz3upBj+4KZFx\n4qBWpvU/6xQRgbbOwfHNzTDl9RSlWSYTXvJ1/7iXYfoSEOMGJSmlGSm/P3Y/\nVPoChK0lfJYanNW4Gu4qQf9d09E5d6NQcGZdN3PNIQ==\n"  },
        { 'last_edited_by_id' => 2, 'signature' => "GYIflo5hjcsEMjTZxnb4gsKV8bOe2XiG88u8IJ5zvJm3ZavLNmeDJ0PCKkpS\nM05NLLzbaqlGyM7Bh7TubanuvWEi412p9qyMABqVnka3co7GWE3N0RHX1JbG\ncq/O86iO3GDCA7YEwZUjdP0UhI+ytA6WNPU/hsmsDJJzaxXs5GFc51XZUBx9\nHYqKc60i1dL1UIi4IlfcvkiBfUg2lXaeJvHjj2zb0i/khpQ6q0H/OPcNE1Vn\nvYgZGN6PLy60KnirPltKynw8fii5FF2QSntINiC5GM64Eir0ZAKyh9lOQWUV\nCQvtoX4MbUXYWIZXt2sc4GzJE74mPmZ0qmD16hT/kA==\n", 'content' => "gQUlhs+uPz93UN/Cpcd7x8ochDXWbfiC6IrP7ijCfxaa9kvsVnQddYkJVgH1\nBLO6SC36b/lVsGfcvUwmO0vefGrSy2XykXVJdYPMf/LQsOukOs1rLVacg4B6\nf0KeKvLVf/HVYcKiY4L2rFIPvuWC+bUWxRThpiABSu1ZCH9qgcR24PPRnwYw\nsTT15OBHmBzhsP+b3NZI9Yh3OIzWLvDSjQmRuldryuUstPsgfWKd/xawPU4D\nJ8EUFGNltFqb+R4n2eGpNSVQCl/+o9gfMG6dq5CE5HRHwpKgXaybdy753lrF\nHWXS4g6apO4lpJS7kXdhHX7OTbA79GHj/ait9fuZLA==\n" }
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

