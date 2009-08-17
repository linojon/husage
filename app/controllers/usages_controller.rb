class UsagesController < ApplicationController
  
  before_filter :require_user, :except => [:index, :refresh_all]
  
  include ActionView::Helpers::TextHelper # pluralize
  
  # GET /usages
  # GET /usages.xml
  def index
    #debugger
    return( redirect_to new_user_session_url) unless current_user #redirect without flash
    @report_user = is_admin? ? User.find_by_site( params[:site] ) : current_user
    @usages = Usage.all :conditions => { :site => current_site }, :order => "period_from DESC"
    return( redirect_to setup_path(:site => current_site)) if @usages.empty?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usages }
    end
  end
  
  def setup
  end
  
  def setup_create
    count = Usage.setup( current_site )
    if count <= 0
      flash[:notice] = "Error creating report.<br/>(Perhaps #{current_site} is not a valid HughesNet Site ID?)"
    else
      current_user.update_attributes( :last_run_at => Time.now )
    end
    redirect_to usages_path
  end
  
  def refresh
    count = Usage.refresh( current_site )
    notify_usage current_user.warning_threshold if current_user.send_emails
    if count < 0
      flash[:notice] = "Error creating report.<br/>(Perhaps #{current_site} is not a valid HughesNet Site ID?)"
    elsif count == 0
      current_user.update_attributes( :last_run_at => Time.now )
      flash[:notice] = 'No new updates'
    else
      Usage.delete_older_than current_site, 30
      current_user.update_attributes( :last_run_at => Time.now )
      flash[:notice] = "Updated #{pluralize count, 'item'}"
    end
    redirect_to usages_path 
  end

  def notify
    notify_usage
    redirect_to usages_path
  end
  
  def original
    # themonth = Time.now.strftime "%Y%%20%m"
    # @hughes_url = "http://customercare.myhughesnet.com/act_usage.cfm?siteid=#{@site_id}&themonth=#{themonth}"
    #debugger
    @usage_html = Usage.fetch_hughes_report( current_site ).xpath('//body') #.to_xhtml(:encoding => 'UTF8')
    if is_9series?
      render :action => 'original-9series', :layout => 'original'
    else
      render :action => :original, :layout => 'original'
    end
  end
  
  protected
  
  def notify_usage( threshold=0 )
    most_recent = Usage.first :conditions => { :site => current_site }, :order => 'period_from DESC'
    # 24hr can be nil during free download periods
    Notifier.deliver_usage_message( current_user, most_recent ) if most_recent && most_recent.download_24hr && 
                                                                  (most_recent.download_24hr >= threshold)
  end
end
