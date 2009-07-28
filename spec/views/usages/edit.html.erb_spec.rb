require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usages/edit.html.erb" do
  include UsagesHelper

  before(:each) do
    assigns[:usage] = @usage = stub_model(Usage,
      :new_record? => false,
      :total => 1
    )
  end

  it "renders the edit usage form" do
    render

    response.should have_tag("form[action=#{usage_path(@usage)}][method=post]") do
      with_tag('input#usage_total[name=?]', "usage[total]")
    end
  end
end
