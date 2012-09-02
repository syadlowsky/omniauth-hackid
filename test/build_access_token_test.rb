module BuildAccessTokenTests
  class TestCase < StrategyTestCase
    include SignedRequestHelpers
  end

  class ParamsContainSignedRequestWithAccessTokenTest < TestCase
    def setup
      super

      @payload = {
        'algorithm' => 'HMAC-SHA256',
        'oauth_token' => 'm4c0d3z',
        'expires' => Time.now.to_i
      }
      @raw_signed_request = signed_request(@payload, @client_secret)
      @request.stubs(:params).returns({"signed_request" => @raw_signed_request})

      strategy.stubs(:callback_url).returns('/')
    end

    test 'returns a new access token from the signed request' do
      result = strategy.build_access_token
      assert_kind_of ::OAuth2::AccessToken, result
      assert_equal @payload['oauth_token'], result.token
    end

    test 'returns an access token with the correct expiry time' do
      result = strategy.build_access_token
      assert_equal @payload['expires'], result.expires_at
    end
  end

  class ParamsContainAccessTokenStringTest < TestCase
    def setup
      super

      @request.stubs(:params).returns({'access_token' => 'm4c0d3z'})

      strategy.stubs(:callback_url).returns('/')
    end

    test 'returns a new access token' do
      result = strategy.build_access_token
      assert_kind_of ::OAuth2::AccessToken, result
      assert_equal 'm4c0d3z', result.token
    end
  end
end
