require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usages/index.html.erb" do
  include UsagesHelper

  before(:each) do
    assigns[:usages] = [
      stub_model(Usage,
        :total => 1
      ),
      stub_model(Usage,
        :total => 1
      )
    ]
  end

  it "renders a list of usages" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
