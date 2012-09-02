class ClientTest < StrategyTestCase
  test 'has correct Facebook site' do
    assert_equal 'https://hackid.herokuapp.com', strategy.client.site
  end

  test 'has correct authorize url' do
    assert_equal '/oauth/authorize', strategy.client.options[:authorize_url]
  end

  test 'has correct token url' do
    assert_equal '/oauth/access_token', strategy.client.options[:token_url]
  end
end

