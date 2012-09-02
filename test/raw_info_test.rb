class RawInfoTest < StrategyTestCase
  def setup
    super
    @access_token = stub('OAuth2::AccessToken')
  end

  test 'performs a GET to https://graph.facebook.com/me' do
    strategy.stubs(:access_token).returns(@access_token)
    @access_token.expects(:get).with('/me').returns(stub_everything('OAuth2::Response'))
    strategy.raw_info
  end

  test 'returns a Hash' do
    strategy.stubs(:access_token).returns(@access_token)
    raw_response = stub('Faraday::Response')
    raw_response.stubs(:body).returns('{ "ohai": "thar" }')
    raw_response.stubs(:status).returns(200)
    raw_response.stubs(:headers).returns({'Content-Type' => 'application/json' })
    oauth2_response = OAuth2::Response.new(raw_response)
    @access_token.stubs(:get).with('/me').returns(oauth2_response)
    assert_kind_of Hash, strategy.raw_info
    assert_equal 'thar', strategy.raw_info['ohai']
  end

  test 'returns an empty hash when the response is false' do
    strategy.stubs(:access_token).returns(@access_token)
    oauth2_response = stub('OAuth2::Response', :parsed => false)
    @access_token.stubs(:get).with('/me').returns(oauth2_response)
    assert_kind_of Hash, strategy.raw_info
  end

  test 'should not include raw_info in extras hash when skip_info is specified' do
    @options = { :skip_info => true }
    strategy.stubs(:raw_info).returns({:foo => 'bar' })
    refute_has_key 'raw_info', strategy.extra
  end
end
