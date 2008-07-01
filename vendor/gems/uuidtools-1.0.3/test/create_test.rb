require 'test/unit'
require 'uuidtools'

class CreateTest < Test::Unit::TestCase
  def setup
  end
  
  def test_sha1_create
    assert_equal(
      "f2d04685-b787-55da-8644-9bd28a6f5a53",
      UUID.sha1_create(UUID_URL_NAMESPACE, 'http://sporkmonger.com').to_s)
  end

  def test_md5_create
    assert_equal(
      "15074785-9071-3fe3-89bd-876e4b9e919b",
      UUID.md5_create(UUID_URL_NAMESPACE, 'http://sporkmonger.com').to_s)
  end
  
  def test_timestamp_create
    assert_not_equal(
      UUID.timestamp_create.to_s,
      UUID.timestamp_create.to_s)
    current_time = Time.now
    assert_not_equal(
      UUID.timestamp_create(current_time).to_s,
      UUID.timestamp_create(current_time).to_s)
    uuids = []
    1000.times do
      uuids << UUID.timestamp_create
    end
    assert_equal(uuids.size, (uuids.map {|x| x.to_s}).uniq.size,
      "Duplicate timestamp-based UUID generated.")
  end

  def test_random_create
    assert_not_equal(
      UUID.random_create.to_s,
      UUID.random_create.to_s)
  end
end