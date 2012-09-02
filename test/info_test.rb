class InfoTest < StrategyTestCase
  test 'returns the secure facebook avatar url when `secure_image_url` option is specified' do
    @options = { :secure_image_url => true }
    raw_info = { 'name' => 'Fred Smith', 'id' => '321' }
    strategy.stubs(:raw_info).returns(raw_info)
    assert_equal 'https://graph.facebook.com/321/picture?type=square', strategy.info['image']
  end

  test 'returns the image size specified in the `image_size` option' do
    @options = { :image_size => 'normal' }
    raw_info = { 'name' => 'Fred Smith', 'id' => '321' }
    strategy.stubs(:raw_info).returns(raw_info)
    assert_equal 'http://graph.facebook.com/321/picture?type=normal', strategy.info['image']
  end
end

class InfoTestOptionalDataPresent < StrategyTestCase
  def setup
    super
    @raw_info ||= { 'name' => 'Fred Smith' }
    strategy.stubs(:raw_info).returns(@raw_info)
  end

  test 'returns the name' do
    assert_equal 'Fred Smith', strategy.info['name']
  end

  test 'returns the email' do
    @raw_info['email'] = 'fred@smith.com'
    assert_equal 'fred@smith.com', strategy.info['email']
  end

  test 'returns the username as nickname' do
    @raw_info['username'] = 'fredsmith'
    assert_equal 'fredsmith', strategy.info['nickname']
  end

  test 'returns the first name' do
    @raw_info['first_name'] = 'Fred'
    assert_equal 'Fred', strategy.info['first_name']
  end

  test 'returns the last name' do
    @raw_info['last_name'] = 'Smith'
    assert_equal 'Smith', strategy.info['last_name']
  end

  test 'returns the location name as location' do
    @raw_info['location'] = { 'id' => '104022926303756', 'name' => 'Palo Alto, California' }
    assert_equal 'Palo Alto, California', strategy.info['location']
  end

  test 'returns bio as description' do
    @raw_info['bio'] = 'I am great'
    assert_equal 'I am great', strategy.info['description']
  end

  test 'returns the square format facebook avatar url' do
    @raw_info['id'] = '321'
    assert_equal 'http://graph.facebook.com/321/picture?type=square', strategy.info['image']
  end

  test 'returns the Facebook link as the Facebook url' do
    @raw_info['link'] = 'http://www.facebook.com/fredsmith'
    assert_kind_of Hash, strategy.info['urls']
    assert_equal 'http://www.facebook.com/fredsmith', strategy.info['urls']['Facebook']
  end

  test 'returns website url' do
    @raw_info['website'] = 'https://my-wonderful-site.com'
    assert_kind_of Hash, strategy.info['urls']
    assert_equal 'https://my-wonderful-site.com', strategy.info['urls']['Website']
  end

  test 'return both Facebook link and website urls' do
    @raw_info['link'] = 'http://www.facebook.com/fredsmith'
    @raw_info['website'] = 'https://my-wonderful-site.com'
    assert_kind_of Hash, strategy.info['urls']
    assert_equal 'http://www.facebook.com/fredsmith', strategy.info['urls']['Facebook']
    assert_equal 'https://my-wonderful-site.com', strategy.info['urls']['Website']
  end

  test 'returns the positive verified status' do
    @raw_info['verified'] = true
    assert strategy.info['verified']
  end

  test 'returns the negative verified status' do
    @raw_info['verified'] = false
    refute strategy.info['verified']
  end
end

class InfoTestOptionalDataNotPresent < StrategyTestCase
  def setup
    super
    @raw_info ||= { 'name' => 'Fred Smith' }
    strategy.stubs(:raw_info).returns(@raw_info)
  end

  test 'has no email key' do
    refute_has_key 'email', strategy.info
  end

  test 'has no nickname key' do
    refute_has_key 'nickname', strategy.info
  end

  test 'has no first name key' do
    refute_has_key 'first_name', strategy.info
  end

  test 'has no last name key' do
    refute_has_key 'last_name', strategy.info
  end

  test 'has no location key' do
    refute_has_key 'location', strategy.info
  end

  test 'has no description key' do
    refute_has_key 'description', strategy.info
  end

  test 'has no urls' do
    refute_has_key 'urls', strategy.info
  end

  test 'has no verified key' do
    refute_has_key 'verified', strategy.info
  end
end
