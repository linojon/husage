require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usages/new.html.erb" do
  include UsagesHelper

  before(:each) do
    assigns[:usage] = stub_model(Usage,
      :new_record? => true,
      :total => 1
    )
  end

  it "renders new usage form" do
    render

    response.should have_tag("form[action=?][method=post]", usages_path) do
      with_tag("input#usage_total[name=?]", "usage[total]")
    end
  end
end
