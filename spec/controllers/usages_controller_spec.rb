require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsagesController do

  def mock_usage(stubs={})
    @mock_usage ||= mock_model(Usage, stubs)
  end
  
  def mock_user( stubs = { :site => '12345'})
    @mock_user ||= mock_model(User, stubs)
  end
  
  before :each do
    attrs = { :site => '12345', :warning_threshold => 300 }
    controller.stub!(:current_user).and_return(mock_user(attrs))
  end

  describe "GET index" do
    it "assigns all usages as @usages" do
      Usage.stub!(:all).and_return([mock_usage])
      get :index
      assigns[:usages].should == [mock_usage]
    end
    
    it "sorts reverse chronological" do
      Usage.should_receive(:all).with( hash_including(:order => "period_from DESC") ).and_return([mock_usage])
      get :index
    end
    
  end
  
  describe "GET refresh" do
    before :each do
      Usage.stub!(:refresh)
      Usage.stub!(:delete_older_than)
      Usage.stub!(:first).and_return(@usage=mock_usage(:download_24hr => 100))
      UsageNotifier.stub!(:deliver_level_message)
    end
    
    it "refreshes the database from the Hughes usage report" do
      Usage.should_receive(:refresh).with('12345')
      get :refresh
    end
    
    it "notifies if most recent is above threshold" do
      @usage.stub!(:download_24hr).and_return(400)
      UsageNotifier.should_receive(:deliver_level_message)
      get :refresh
    end
    
    it "doesnt notify if most recent is below threshold" do
      UsageNotifier.should_receive(:deliver_level_message).never
      get :refresh
    end
    
    it "redirects to index when done" do
      get :refresh
      response.should redirect_to('/usages')
    end
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
