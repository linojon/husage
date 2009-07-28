require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsagesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "usages", :action => "index").should == "/usages"
    end

    it "maps #new" do
      route_for(:controller => "usages", :action => "new").should == "/usages/new"
    end

    it "maps #show" do
      route_for(:controller => "usages", :action => "show", :id => "1").should == "/usages/1"
    end

    it "maps #edit" do
      route_for(:controller => "usages", :action => "edit", :id => "1").should == "/usages/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "usages", :action => "create").should == {:path => "/usages", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "usages", :action => "update", :id => "1").should == {:path =>"/usages/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "usages", :action => "destroy", :id => "1").should == {:path =>"/usages/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/usages").should == {:controller => "usages", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/usages/new").should == {:controller => "usages", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/usages").should == {:controller => "usages", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/usages/1").should == {:controller => "usages", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/usages/1/edit").should == {:controller => "usages", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/usages/1").should == {:controller => "usages", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/usages/1").should == {:controller => "usages", :action => "destroy", :id => "1"}
    end
  end
end
