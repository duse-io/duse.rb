require 'sinatra/base'
require 'duse/client/session'

private_key = "-----BEGIN RSA PRIVATE KEY-----\nMIICWgIBAAKBgQCftZvHkB6uKWVDvrIzmy2p496Hv9PD/hhRk+DSXcE/CPtRmvYZ\nzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTeNdlaH9cRFV2wc2A/hbg2kaIS\nxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET2XM6tZcuwFULX6bl8QIDAQAB\nAoGAEJwyt26lwjdL8N/EaNmaxjCM1FF/FMM4hEN8/mQB1Sx59uLG9agPWzrDJcoS\nlH7ZalKLwpORTuCYvCtKH7Qm+fgnjKl/qyn6/cDmtk6VtJvPjQGi3oh2eRIMcwZv\nva+NQLF11bm0kVtZG5viIKlb1snHzkpPjFAOPBqQj2FNdgECQQDQdHWC5XYww2RQ\n/FpRBacJPIxb8PAwb7+EjqJSaruGO9CtLiDiCzlmidGP0Q++zwjAxksSqP4qkr6k\npKvDqkydAkEAxCLuq0c+6gnE9X1PUy4Bl/hUOxrk3ZQRCMUCE4XB8mNmJTLNY43O\ncY7Z1sdaCu7pAiGxQqojUYgwFACGmbOcZQJAZAvg8mfq59B/bxcOyeAqoRY8T0w+\nGyEnDBng8iljwzMmHlgLVDIK5Jm0yI+QPQXkr5D8KwKMqiYv9ZlLDufHSQJAJs9i\nurGWWWkleA4brDHmTtPsluVzdATgegPBrWtCPVw90g6DZbehqgbCRCWeQ5uSr8FK\n+g4AfxmbqdmQyMkpoQI/HvHjjPB9a/2qkpyjeiJIx2gmCmhBke9V/b3XFGBy3ci7\nLZRZUZLlAdJORX177Ief6MWqgXldlcP1N7mzWskE\n-----END RSA PRIVATE KEY-----\n"

module Duse
  module Client
    class Session
      class FakeAPI < Sinatra::Base
        disable :protection
        enable :raise_errors

        before do
          content_type :json
        end

        def authorized?
          env['HTTP_AUTHORIZATION'] == 'token'
        end

        get '/v1/users' do
          [{
            'id' => 1,
            'username' => 'server',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/1'
          }, {
            'id' => 2,
            'username' => 'flower-pot',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/2'
          }, {
            'id' => 3,
            'username' => 'adracus',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/3'
          }].to_json
        end

        post '/v1/users' do
          {
            'id' => 2,
            'username' => 'flower-pot',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/2'
          }.to_json
        end

        get '/v1/users/me' do
          {
            'id' => 2,
            'username' => 'flower-pot',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCftZvHkB6uKWVDvrIzmy2p496H\nv9PD/hhRk+DSXcE/CPtRmvYZzbWbbBup9hkvhyH/P1O5EF8KSZm4Cdnz6p37idTe\nNdlaH9cRFV2wc2A/hbg2kaISxrDxUqRbywBE9NOBSjXu2wRpy0TMo85eM2A0E2ET\n2XM6tZcuwFULX6bl8QIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/2'
          }.to_json
        end

        get '/v1/users/server' do
          {
            'id' => 1,
            'username' => 'server',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDC8Z1K4aCksOb6rsbKNcF4fNcN\n1Tbyv+ids751YvmfU2WHDXB3wIVoN1YRdb8Dk8608YlGAAqVaGVwfgYdyLMppIGs\nglZIMjwZFM2F84T4swKOEJJx6o3ZCRnP9ZQcceqzcIuTjiIqC7xu+QOvtADAMW68\nzZIpFOHjjiuxkA7PQQIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/1'
          }.to_json
        end

        get '/v1/users/3' do
          {
            'id' => 3,
            'username' => 'adracus',
            'public_key' => "-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTF2gEqXRy2hJ6+xjj6IbzAgHG\nHvnLNnZlwkYm0ZV89uiPxL9mKYNiW4KA1azZlvJZviTF4218WAwO1IGIH+PppdXF\nIK8vmB6IIaQcO4UTjSA6ZTn8Uwf1fwS4EAuL3Zr3IVdjVYQ4+/ZNtmSyVMmo+7zP\nyOa31hUhDNYrJO1iEQIDAQAB\n-----END PUBLIC KEY-----\n",
            'url' => 'https://example.com/v1/users/3'
          }.to_json
        end

        get '/v1/secrets' do
          [{
            'id' => 1,
            'title' => 'test',
            'required' => 2,
            'url' => 'http://example.com/v1/secrets/1'
          }].to_json
        end

        get '/v1/secrets/1' do
          {
            'id' => 1,
            'title' => 'test',
            'required' => 2,
            'shares' => [[
              "FlWfp7jBNQj5Ad2Fes36rQA3Xunm/rD7EhMdTxQvwpTdgEw8Co7Dywc6hiA6\nx0B3ICayX4q4r4DSFCsEFlwboTW+fKTHW7n4Jvym2tnc9DsELmcnpCC+tgGb\nbCOLR5XNXncby1gmIXrqoz+VJVkSbuz/8uFubJMEHP+iZx8Efds=\n",
              "XMcasmkkD0eOB52ilT3sGUOy9ehHpsuIFnbmErKLsTq0PExcvSuGT6RwMKjE\nM3rS7Lu2nHgWm0IPSzi5Vd8ieJTgyayYgT9VCOOnKGqfAMmCpV0WrHpfNwLu\nUgH7VC3Wfk1F+6yzWAFOoYXBDUuIRRau4uswCpedp1pe3csmO+I=\n"
            ]],
            'url' => 'http://example.com/v1/secrets/1'
          }.to_json
        end

        post '/v1/secrets' do
          {
            'id' => 1,
            'title' => 'test',
            'required' => 2,
            'shares' => [[
              "FlWfp7jBNQj5Ad2Fes36rQA3Xunm/rD7EhMdTxQvwpTdgEw8Co7Dywc6hiA6\nx0B3ICayX4q4r4DSFCsEFlwboTW+fKTHW7n4Jvym2tnc9DsELmcnpCC+tgGb\nbCOLR5XNXncby1gmIXrqoz+VJVkSbuz/8uFubJMEHP+iZx8Efds=\n",
              "XMcasmkkD0eOB52ilT3sGUOy9ehHpsuIFnbmErKLsTq0PExcvSuGT6RwMKjE\nM3rS7Lu2nHgWm0IPSzi5Vd8ieJTgyayYgT9VCOOnKGqfAMmCpV0WrHpfNwLu\nUgH7VC3Wfk1F+6yzWAFOoYXBDUuIRRau4uswCpedp1pe3csmO+I=\n"
            ]],
            'url' => 'http://example.com/v1/secrets/1'
          }.to_json
        end
      end

      def faraday_adapter
        [:rack, FakeAPI.new]
      end
    end
  end
end
