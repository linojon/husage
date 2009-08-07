class User < ActiveRecord::Base
  has_many :usages
  
  acts_as_authentic do |c|
    c.login_field = 'site'
    c.validates_format_of_login_field_options = { :case_sensitive => false, :with => /^[a-f0-9]+$/i, :message => "may only contain numbers and letters A-F." }
      # This should also work: /^[[:xdigit:]]+$/
    c.validates_uniqueness_of_email_field_options = {:if => "false"}    
  end
  
  def before_validation
    self.warning_threshold ||= 300
    self.alert_threshold ||= 350
    self.send_emails ||= true
    self.send_emails = nil if email.blank?
    self.run_cron ||= true
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
end
