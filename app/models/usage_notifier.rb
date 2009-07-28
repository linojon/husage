class UsageNotifier < ActionMailer::Base

  def level_message( usage )
    @recipients = "jonathan@linowes.com, lisa@linowes.com"
    @from       = "admin@linowes.com"
    @subject    = "Hughes Usage Alert: #{usage.download_24hr}MB"
    @sent_on    = Time.now
    @headers    = {}
    @body       = { :usage => usage }
  end
    

end
