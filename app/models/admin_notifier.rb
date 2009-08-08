class AdminNotifier < ActionMailer::Base
  
  def message( subject, message, user=nil )
    #debugger
    setup_email(Time.now)
    @subject  += subject
    @body[:message] = message
    @body[:user] = user
  end

  private
  
  def setup_email( sent_at )
    @recipients = 'jonathan@parkerhill.com'
    @from       = 'admin@husage.net'
    @subject    = 'Husage Admin: '
    @sent_on    = sent_at
    @headers    = {}
    #@headers = {content_type => 'text/html'}
  end
end

