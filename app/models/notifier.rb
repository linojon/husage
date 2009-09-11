class Notifier < ActionMailer::Base  
  default_url_options[:host] = "husage.net"  
  
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "Husage <husage.net@gmail.com>"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  
  
  def usage_message( user, usage )
    level = (usage.download_24hr >= user.alert_threshold) ? "Alert" : "Warning"
    subject       "Husage #{level}: #{usage.download_24hr}MB"
    from          "Husage <husage.net@gmail.com>"
    recipients    user.email + (user.other_emails.blank? ? '' : ', '+user.other_emails )
    sent_on       Time.now
    body          :user => user, :usage => usage
  end
  
  def admin_message( subj, user=nil, message=nil )
    subject       "Husage Admin: #{subj}"
    from          "Husage <husage.net@gmail.com>"
    recipients    "husage.net@gmail.com"
    sent_on       Time.now
    body          :user => user, :message => message||subj
  end
end
