require 'test/unit'
require 'uuidtools'

class MacAddressTest < Test::Unit::TestCase
  def setup
  end
  
  def test_mac_address_object
    mac_address = UUID.mac_address
    assert_not_nil(mac_address)
    assert_equal(mac_address.object_id, UUID.mac_address.object_id)
  end
end