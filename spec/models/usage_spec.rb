require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usage do
  before(:each) do
    @valid_attributes = {
      :created_at => Time.now,
      :total => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Usage.create!(@valid_attributes)
  end
end
