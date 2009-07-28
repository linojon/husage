require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsagesController do

  def mock_usage(stubs={})
    @mock_usage ||= mock_model(Usage, stubs)
  end

  describe "GET index" do
    it "assigns all usages as @usages" do
      Usage.stub!(:find).with(:all).and_return([mock_usage])
      get :index
      assigns[:usages].should == [mock_usage]
    end
    
    it "paginates the list"
    
  end
  
  describe "GET refresh" do
    it "finds the Hughesnet usage report"
    it "load new usages into the database"
    it "ignores existing usages in the database"
    it "calculates 24 hour downloads where undefined"
    it "calculates 24 hour uploads where undefined"
  end

  # describe "GET show" do
  #   it "assigns the requested usage as @usage" do
  #     Usage.stub!(:find).with("37").and_return(mock_usage)
  #     get :show, :id => "37"
  #     assigns[:usage].should equal(mock_usage)
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "assigns a new usage as @usage" do
  #     Usage.stub!(:new).and_return(mock_usage)
  #     get :new
  #     assigns[:usage].should equal(mock_usage)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested usage as @usage" do
  #     Usage.stub!(:find).with("37").and_return(mock_usage)
  #     get :edit, :id => "37"
  #     assigns[:usage].should equal(mock_usage)
  #   end
  # end
  # 
  # describe "POST create" do
  # 
  #   describe "with valid params" do
  #     it "assigns a newly created usage as @usage" do
  #       Usage.stub!(:new).with({'these' => 'params'}).and_return(mock_usage(:save => true))
  #       post :create, :usage => {:these => 'params'}
  #       assigns[:usage].should equal(mock_usage)
  #     end
  # 
  #     it "redirects to the created usage" do
  #       Usage.stub!(:new).and_return(mock_usage(:save => true))
  #       post :create, :usage => {}
  #       response.should redirect_to(usage_url(mock_usage))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved usage as @usage" do
  #       Usage.stub!(:new).with({'these' => 'params'}).and_return(mock_usage(:save => false))
  #       post :create, :usage => {:these => 'params'}
  #       assigns[:usage].should equal(mock_usage)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       Usage.stub!(:new).and_return(mock_usage(:save => false))
  #       post :create, :usage => {}
  #       response.should render_template('new')
  #     end
  #   end
  # 
  # end
  # 
  # describe "PUT update" do
  # 
  #   describe "with valid params" do
  #     it "updates the requested usage" do
  #       Usage.should_receive(:find).with("37").and_return(mock_usage)
  #       mock_usage.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :usage => {:these => 'params'}
  #     end
  # 
  #     it "assigns the requested usage as @usage" do
  #       Usage.stub!(:find).and_return(mock_usage(:update_attributes => true))
  #       put :update, :id => "1"
  #       assigns[:usage].should equal(mock_usage)
  #     end
  # 
  #     it "redirects to the usage" do
  #       Usage.stub!(:find).and_return(mock_usage(:update_attributes => true))
  #       put :update, :id => "1"
  #       response.should redirect_to(usage_url(mock_usage))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "updates the requested usage" do
  #       Usage.should_receive(:find).with("37").and_return(mock_usage)
  #       mock_usage.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :usage => {:these => 'params'}
  #     end
  # 
  #     it "assigns the usage as @usage" do
  #       Usage.stub!(:find).and_return(mock_usage(:update_attributes => false))
  #       put :update, :id => "1"
  #       assigns[:usage].should equal(mock_usage)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Usage.stub!(:find).and_return(mock_usage(:update_attributes => false))
  #       put :update, :id => "1"
  #       response.should render_template('edit')
  #     end
  #   end
  # 
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested usage" do
  #     Usage.should_receive(:find).with("37").and_return(mock_usage)
  #     mock_usage.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the usages list" do
  #     Usage.stub!(:find).and_return(mock_usage(:destroy => true))
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(usages_url)
  #   end
  # end

end
