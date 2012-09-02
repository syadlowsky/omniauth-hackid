class ExtraTest < StrategyTestCase
  def setup
    super
    @raw_info = { 'name' => 'Fred Smith' }
    strategy.stubs(:raw_info).returns(@raw_info)
  end

  test 'returns a Hash' do
    assert_kind_of Hash, strategy.extra
  end

  test 'contains raw info' do
    assert_equal({ 'raw_info' => @raw_info }, strategy.extra)
  end
end
