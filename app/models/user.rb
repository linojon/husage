class User < ActiveRecord::Base
  
  attr_accessor :hn_plan
  
  HN_PLANS = {
    'Home'        => { :fap => 200, :alert => 175, :warn => 150 }, 
    'Pro'         => { :fap => 300, :alert => 260, :warn => 225 },
    'ProPlus'     => { :fap => 425, :alert => 375, :warn => 325 },
    'Elite'       => { :fap => 500, :alert => 440, :warn => 375 },
    'Sm Office'   => { :fap => 500, :alert => 440, :warn => 375 },
    'Business'    => { :fap => 1250, :alert => 1100, :warn => 850 }
  }
  HN_PLAN_NAMES = ['Home', 'Pro', 'ProPlus', 'Elite', 'Sm Office', 'Business']
    
  acts_as_authentic do |c|
    c.login_field = 'site'
    #c.validates_format_of_login_field_options = { :case_sensitive => false, :with => /^[a-f0-9]+$/i, :message => "may only contain numbers and letters A-F." }
      # This should also work: /^[[:xdigit:]]+$/
    #c.validates_format_of_login_field_options = { :case_sensitive => false }
    c.validates_uniqueness_of_email_field_options = {:if => "false"}    
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end  
  
  
  #
  
  def before_validation
    default_mb = HN_PLANS[ hn_plan ] || HN_PLANS[ 'Home' ]
    self.warning_threshold ||= default_mb[:warn]
    self.alert_threshold ||= default_mb[:alert]
    self.fap_threshold ||= default_mb[:fap]
    
    self.send_emails ||= true
    self.send_emails = nil if email.blank?
    self.run_cron ||= true
    
    self.site.strip!
    true
  end
  
  def validate
    unless other_emails.blank?
      emails = other_emails.split(/,|\s/) #(/[,|\r\n]/)
      emails.delete_if {|em| em.blank? }
      if emails.any? {|em| (em =~ Authlogic::Regex.email).nil? }
        errors.add(:other_emails, "contains an invalid email address") 
      else
        self.other_emails = emails.join(', ')
      end
    end
  end
  
  def before_destroy
    Usage.delete_all ["site = ?", site]
  end
end
