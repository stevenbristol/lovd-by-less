require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe UUID, "when generating" do
  it "should correctly generate SHA1 variant UUIDs" do
    UUID.sha1_create(
      UUID_URL_NAMESPACE, 'http://sporkmonger.com'
    ).to_s.should == "f2d04685-b787-55da-8644-9bd28a6f5a53"
  end

  it "should correctly generate MD5 variant UUIDs" do
    UUID.md5_create(
      UUID_URL_NAMESPACE, 'http://sporkmonger.com'
    ).to_s.should == "15074785-9071-3fe3-89bd-876e4b9e919b"
  end

  it "should correctly generate timestamp variant UUIDs" do
    UUID.timestamp_create.to_s.should_not == UUID.timestamp_create.to_s
    current_time = Time.now
    UUID.timestamp_create(current_time).to_s.should_not ==
      UUID.timestamp_create(current_time).to_s
    uuids = []
    1000.times do
      uuids << UUID.timestamp_create
    end
    # Check to make sure that none of the 10,000 UUIDs were duplicates
    (uuids.map {|x| x.to_s}).uniq.size.should == uuids.size
  end

  it "should correctly generate random number variant UUIDs" do
    uuids = []
    1000.times do
      uuids << UUID.random_create
    end
    # Check to make sure that none of the 10,000 UUIDs were duplicates
    (uuids.map {|x| x.to_s}).uniq.size.should == uuids.size
  end
end
