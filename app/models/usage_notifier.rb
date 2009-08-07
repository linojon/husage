class UsageNotifier < ActionMailer::Base

  def level_message( user, usage )
    @recipients = user.email 
    @recipients += user.other_emails unless user.other_emails.blank? 
    @from       = "husage@husage.com"
    @subject    = "Husage Alert: #{usage.download_24hr}MB"
    @sent_on    = Time.now
    @headers    = {}
    @body       = { :user => user, :usage => usage }
  end
    

end
