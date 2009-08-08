# see http://www.railsenvy.com/2007/6/11/ruby-on-rails-rake-tutorial

namespace :husage do
  desc "Hello wURLd"
  task :hello do
    puts "hello wURLd"
    logger.info("#{Time.now} said hello!")
  end
  
  desc "Refresh the usage reports for each site"
  task :refreshAll => :environment do
    logger.info("#{Time.now} ================ start refeshAll ================")
    users = User.all :conditions => ["run_cron = ?", true]
    users.each do |user|
      count = Usage.refresh( user.site )
      notify_usage user if user.send_emails
      Usage.delete_older_than user.site, 30
      logger.info("#{user.site}: #{count} updated")
    end
    logger.info("#{Time.now} ================ end refeshAll ================")
  end
  
  #desc "Purge invalid accounts"
  #task :purgeInvalid
end

def logger
  @@logger ||= Logger.new("#{RAILS_ROOT}/log/rake.log")
end

# copied from usages_controller (but has user arg): dry this
def notify_usage( user )
  most_recent = Usage.first :conditions => { :site => user.site }, :order => 'period_from DESC'
  # 24hr can be nil during free download periods
  Notifier.deliver_usage_message( user, most_recent ) if most_recent && most_recent.download_24hr && 
                                                              most_recent.download_24hr >= user.warning_threshold
end
