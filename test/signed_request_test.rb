module SignedRequestHelpers
  def signed_request(payload, secret)
    encoded_payload = base64_encode_url(MultiJson.encode(payload))
    encoded_signature = base64_encode_url(signature(encoded_payload, secret))
    [encoded_signature, encoded_payload].join('.')
  end

  def base64_encode_url(value)
    Base64.encode64(value).tr('+/', '-_').gsub(/\n/, '')
  end

  def signature(payload, secret, algorithm = OpenSSL::Digest::SHA256.new)
    OpenSSL::HMAC.digest(algorithm, secret, payload)
  end
end

module SignedRequestTests
  class TestCase < StrategyTestCase
    include SignedRequestHelpers
  end

  class CookieAndParamNotPresentTest < TestCase
    test 'is nil' do
      assert_nil strategy.send(:signed_request)
    end
  end

  class CookiePresentTest < TestCase
    def setup
      super
      @payload = {
        'algorithm' => 'HMAC-SHA256',
        'code' => 'm4c0d3z',
        'issued_at' => Time.now.to_i,
        'user_id' => '123456'
      }

      @request.stubs(:cookies).returns({"fbsr_#{@client_id}" => signed_request(@payload, @client_secret)})
    end

    test 'parses the access code out from the cookie' do
      assert_equal @payload, strategy.send(:signed_request)
    end
  end

  class ParamPresentTest < TestCase
    def setup
      super
      @payload = {
        'algorithm' => 'HMAC-SHA256',
        'oauth_token' => 'XXX',
        'issued_at' => Time.now.to_i,
        'user_id' => '123456'
      }

      @request.stubs(:params).returns({'signed_request' => signed_request(@payload, @client_secret)})
    end

    test 'parses the access code out from the param' do
      assert_equal @payload, strategy.send(:signed_request)
    end
  end

  class CookieAndParamPresentTest < TestCase
    def setup
      super
      @payload_from_cookie = {
        'algorithm' => 'HMAC-SHA256',
        'from' => 'cookie'
      }

      @request.stubs(:cookies).returns({"fbsr_#{@client_id}" => signed_request(@payload_from_cookie, @client_secret)})

      @payload_from_param = {
        'algorithm' => 'HMAC-SHA256',
        'from' => 'param'
      }

      @request.stubs(:params).returns({'signed_request' => signed_request(@payload_from_param, @client_secret)})
    end

    test 'picks param over cookie' do
      assert_equal @payload_from_param, strategy.send(:signed_request)
    end
  end
end

class RequestPhaseWithSignedRequestTest < StrategyTestCase
  include SignedRequestHelpers

  def setup
    super

    payload = {
      'algorithm' => 'HMAC-SHA256',
      'oauth_token' => 'm4c0d3z'
    }
    @raw_signed_request = signed_request(payload, @client_secret)
    @request.stubs(:params).returns("signed_request" => @raw_signed_request)

    strategy.stubs(:callback_url).returns('/')
  end

  test 'redirects to callback passing along signed request' do
    strategy.expects(:redirect).with("/?signed_request=#{Rack::Utils.escape(@raw_signed_request)}").once
    strategy.request_phase
  end
end

