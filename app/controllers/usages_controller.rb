class UsagesController < ApplicationController

  # GET /usages
  # GET /usages.xml
  def index
    @usages = Usage.all :order => "period_from DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usages }
    end
  end

  def refresh
    Usage.refresh
    notify_usage Usage::LEVEL_ORANGE
    Usage.delete_older_than 30
    redirect_to '/'
  end
  
  def notify
    notify_usage
    redirect_to '/'
  end
  
  protected
  
  def notify_usage( threshold=0 )
    most_recent = Usage.first :order => 'period_from DESC'
    # 24hr can be nil during free download periods
    UsageNotifier.deliver_level_message( most_recent ) if most_recent.download_24hr && most_recent.download_24hr >= threshold
  end
end
