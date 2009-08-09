class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # automatic login
      UserSession.create(:site => params[:user][:site], :password => params[:user][:password])
      flash[:notice] = "Registration successful."
      #redirect_back_or_default account_url
      Notifier.deliver_admin_message "Created new user/site", @user
      redirect_to usages_url
    else
      render :action => :new
    end
  end
  
  # def show
  #   @user = @current_user
  # end
 
  def edit
    @user = current_user
  end
  
  def update
    #debugger
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Preferences updated."
      redirect_to usages_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    site = current_site
    user = current_user
    current_user_session.destroy
    user.destroy
    flash[:notice] = "Husage reports and login deleted for #{site}"
    Notifier.deliver_admin_message "Deleted user/site", user
    redirect_to login_url
  end
  
end
