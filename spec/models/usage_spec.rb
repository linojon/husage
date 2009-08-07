require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usage do
  before(:each) do
    @valid_attributes = {
      :site => '12345',
      :period_from => "7/11/2009 1:00",
      :min_used => '5',
      :download => '100',
      :fap => 'No',
      :upload => '6'
    }
  end

  it "should create a new instance given valid attributes" do
    Usage.create!(@valid_attributes)
  end
  
  it "should validate uniqueness for date+hour_from" do
    Usage.create(@valid_attributes)
    u = Usage.create(@valid_attributes)
    u.should_not be_valid
    u.errors.on(:period_from).should == "has already been taken"
  end

  it "should scope date+hour_from by site" do
    Usage.create(@valid_attributes)
    @valid_attributes[:site] = "98765"
    u = Usage.create(@valid_attributes)
    u.should be_valid
  end
  
end

# describe Usage, "setup" do
#   it "should get reports for this month and last month" do
#     Usage.setup( '3BC44601')
#     # Usage.should_receive(:fetch_hughes_report).with( ['12345', true], '12345')
#   end
# end

describe Usage, "refresh" do
  
  it "should fetch_hughes_report for site" do
    report = Usage.fetch_hughes_report '3BC44601'
    report.to_s.should include('<div align="center" class="mainText"><strong>Results for Site ID: &nbsp;&nbsp;3BC44601</strong></div>')
  end
  
  it "should parse_and_save_usages on one" do
    report = Nokogiri::HTML( open( "spec/fixtures/act_usage_single.html" ))
    report.to_s.should include('<div align="center" class="mainText"><strong>Results for Site ID: &nbsp;&nbsp;3BC44601</strong></div>')
    Usage.should_receive(:create).with( :site => '12345', :period_from => '08/01/2009 0:00', :min_used => '60', :download => '10.12', :fap => 'No', :upload => '1.09' )
    Usage.parse_and_save_usages '12345', report
  end
  
  it "should parse_and_save_usages on many" do
    report = Nokogiri::HTML( open( "spec/fixtures/act_usage.html" ))
    report.to_s.should include('<div align="center" class="mainText"><strong>Results for Site ID: &nbsp;&nbsp;3BC44601</strong></div>')
    Usage.should_receive(:create).exactly(86).times
    Usage.parse_and_save_usages '12345', report    
  end
  
  it "should calculate_24hour_totals" do
    report = Nokogiri::HTML( open( "spec/fixtures/act_usage.html" ))
    report.to_s.should include('<div align="center" class="mainText"><strong>Results for Site ID: &nbsp;&nbsp;3BC44601</strong></div>')
    Usage.parse_and_save_usages '12345', report

    Usage.calculate_24hour_totals '12345'
    usages = Usage.all
    usages.last.download_24hr.should == 275
    usages[-2].download_24hr.should == 269
  end
  
  it "should ignore free periods in calculations"
  it "should calc totals only when not defined"
end

describe Usage, "delete older" do
  
  it "should delete_older_than specified days" do
    report = Nokogiri::HTML( open( "spec/fixtures/act_usage.html" ))
    Usage.parse_and_save_usages '12345', report
    Usage.count.should == 86
    Usage.delete_older_than( '12345', 1, Time.zone.parse("08/04/2009 15:00") )
    Usage.count.should == 24
    Usage.first.period_from.should == Time.zone.parse("08/03/2009 16:00")
  end

end