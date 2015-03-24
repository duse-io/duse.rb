# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider
# making a separate helper file that requires the additional dependencies and
# performs the additional setup, and require it from the spec files that
# actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'support/helpers'
require 'webmock/rspec'
require 'duse'
require 'duse/cli'
require 'json'

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
    'parts' => [[
      "dVp1FjdfbtGF371TABXSeJ9HNPm9uBYQGaSyBasXqFmnGQqCiZEF0UWPTaG9\nwM7KV1GPwbj/GowwPT0Q8mv9wZ/bCQ2NlQ8Usuiol2SWtGtAYU74C6jzbQH6\ni1gq55I/T8JMiZmebnlnh/7rr9hOh9lQcjylbH792stsntxwlu4=\n",
      "ZfP2yMLwNOe2yBU6UDrOjnE9OX0SX/xbfG+s4mjji6cvfmN7uuyoWTPa3tb8\n6/hNENIpRa/RPGTzeh/jeU7wYIiG3HGb6Z221S6ikEXYNtRqL0plOq8nY+kh\nxV+3PlBXhNNdUvtUTf3D5dtfWdxL2tuPJUnTnWyoNSDko+NXlHM=\n"
    ]],
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

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description # => "be bigger than 2
    # and smaller than 4" ...rather than: # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Helpers

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  Kernel.srand config.seed
end
