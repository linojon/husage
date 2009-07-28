require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usages/show.html.erb" do
  include UsagesHelper
  before(:each) do
    assigns[:usage] = @usage = stub_model(Usage,
      :total => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
  end
end
