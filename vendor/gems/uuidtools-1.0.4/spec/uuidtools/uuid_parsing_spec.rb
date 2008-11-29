require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe UUID, "when parsing" do
  it "should correctly parse the MAC address from a timestamp version UUID" do
    UUID.timestamp_create.mac_address.should == UUID.mac_address
  end

  it "should correctly parse the variant from a timestamp version UUID" do
    UUID.timestamp_create.variant.should == 0b100
  end

  it "should correctly parse the version from a timestamp version UUID" do
    UUID.timestamp_create.version.should == 1
  end

  it "should correctly parse the timestamp from a timestamp version UUID" do
    UUID.timestamp_create.timestamp.should < Time.now + 1
    UUID.timestamp_create.timestamp.should > Time.now - 1
  end

  it "should not treat a timestamp version UUID as a nil UUID" do
    UUID.timestamp_create.should_not be_nil_uuid
  end

  it "should not treat a timestamp version UUID as a random node UUID" do
    UUID.timestamp_create.should_not be_random_node_id
  end

  it "should treat a timestamp version UUID as a random node UUID " +
      "if there is no MAC address" do
    old_mac_address = UUID.mac_address
    UUID.mac_address = nil
    UUID.timestamp_create.should be_random_node_id
    UUID.mac_address = old_mac_address
  end
end
