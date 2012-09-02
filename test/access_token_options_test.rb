class AccessTokenOptionsTest < StrategyTestCase
  test 'has correct param name by default' do
    assert_equal 'access_token', strategy.access_token_options[:param_name]
  end

  test 'has correct header format by default' do
    assert_equal 'OAuth %s', strategy.access_token_options[:header_format]
  end
end
