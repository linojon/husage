class Notifier < ActionMailer::Base  
  default_url_options[:host] = "husage.net"  
  
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "Husage Notifier <husage.net@gmail.com>"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  
  
  def usage_message( user, usage )
    subject       "Husage Alert: #{usage.download_24hr}MB"
    from          "Husage Notifier <husage.net@gmail.com>"
    recipients    user.email 
    recipients    += user.other_emails unless user.other_emails.blank? 
    sent_on       Time.now
    body          :user => user, :usage => usage
  end
  
  def admin_message( subj, user=nil, message=nil )
    subject       "Husage Admin: #{subj}"
    from          "Husage Notifier <husage.net@gmail.com>"
    recipients    "husage.net@gmail.com"
    sent_on       Time.now
    body          :user => user, :message => message||subj
  end
end
