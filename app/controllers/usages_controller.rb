class UsagesController < ApplicationController
  
  before_filter :require_user, :except => :index
  
  include ActionView::Helpers::TextHelper # pluralize
  
  # GET /usages
  # GET /usages.xml
  def index
    # debugger
    return( redirect_to new_user_session_url) unless current_user #redirect without flash
    @usages = Usage.all :conditions => { :site => current_site }, :order => "period_from DESC"
    return redirect_to setup_path if @usages.empty?
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usages }
    end
  end
  
  def setup
  end
  
  def setup_create
    count = Usage.setup( current_site )
    if count == 0
      flash[:notice] = "Error creating report."
    end
    redirect_to usages_path
  end
  
  def refresh
    count = Usage.refresh( current_site )
    notify_usage current_user.warning_threshold
    if count == 0
      flash[:notice] = 'No new updates'
    else
      flash[:notice] = "Updated #{pluralize count, 'item'}"
    end
    Usage.delete_older_than current_site, 30
    redirect_to usages_path 
  end
  
  def notify
    notify_usage
    redirect_to usages_path
  end
  
  def original
    # themonth = Time.now.strftime "%Y%%20%m"
    # @hughes_url = "http://customercare.myhughesnet.com/act_usage.cfm?siteid=#{@site_id}&themonth=#{themonth}"
    @usage_html = Usage.fetch_hughes_report( current_site ).xpath('//body').to_s
    render :action => :original, :layout => 'original'
  end
  
  protected
  
  def notify_usage( threshold=0 )
    most_recent = Usage.first :conditions => { :site => current_site }, :order => 'period_from DESC'
    # 24hr can be nil during free download periods
    UsageNotifier.deliver_level_message( current_user, most_recent ) if most_recent && most_recent.download_24hr && 
                                                                        most_recent.download_24hr >= threshold
  end
end
