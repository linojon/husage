class Usage < ActiveRecord::Base
  
  require 'nokogiri'
  require 'open-uri'
  
  validates_presence_of :site
  validates_uniqueness_of :period_from, :scope => :site
  
  EASTERN = "Eastern Time (US & Canada)"
  FREE_HOURS = (2...7) #Eastern

  # instance methods
  
  def in_free_period?
    FREE_HOURS.include? period_from.in_time_zone(EASTERN).hour
  end

  # class methods
  
  def self.setup( site )
    report = fetch_hughes_report( site, lastmonth=true )
    parse_and_save_usages site, report
    report = fetch_hughes_report( site )
    parse_and_save_usages site, report
    count = calculate_24hour_totals site
    delete_older_than site, 30
  end
  
  def self.refresh( site )
    #debugger
    report = fetch_hughes_report( site )
    parse_and_save_usages site, report
    count = calculate_24hour_totals site
  end

  def self.delete_older_than( site, days, now=nil )
    now ||= Time.now
    self.destroy_all ["site = ? AND period_from <= ?", site, (now - days.days)]
  end
  
  # def self.current_usage
  #   most_recent = Usage.first :order => 'period_from DESC'
  #   @usage = most_recent if most_recent.period_from.hour == Time.now.hour
  # end
  
  protected
  
  def self.fetch_hughes_report( site, lastmonth=false )
    # themonth in the format "2009 07"
    if lastmonth
      themonth = (Time.now.in_time_zone(EASTERN) - 1.month).strftime "%Y%%20%m"
    else
      themonth = Time.now.in_time_zone(EASTERN).strftime "%Y%%20%m"
    end
    Nokogiri::HTML( open( "http://customercare.myhughesnet.com/act_usage.cfm?siteid=#{site}&themonth=#{themonth}" ))
    #Nokogiri::HTML( open("http://localhost:3003/testdata/act_usage1.html"))
  end
  
  def self.parse_and_save_usages( site, report ) 
    # temporarily use eastern time, that's what the reports are
    current_zone = Time.zone
    Time.zone = EASTERN
    rows = report.xpath("//div[@class='mainText']/following::table/tr").to_a #need to explicitly convert to array
    rows[3..-4].each do |row|
      #debugger
      tds = row.xpath("td")
      date, time_from, time_to, min_used, download, fap, upload = tds.collect {|td| td.content.gsub("\302\240",'').strip }
      # puts [date, time_to, download].join(' | ')
      period_from = [date, time_from].join(' ')
      unless Usage.first( :conditions => { :site => site, :period_from => period_from } )
        usage = Usage.create( :site => site, :period_from => period_from, :min_used => min_used, 
          :download => download, :fap => fap, :upload => upload  )
      end
    end unless rows[3..-4].nil?
    Time.zone = current_zone
  end
  
  # returns number of usages that had nil totals
  def self.calculate_24hour_totals( site )
    usages = Usage.all :conditions => { :site => site, :download_24hr => nil }
    # skip free periods (could do in find but for timezone?)
    usages.delete_if {|usage| usage.in_free_period? }
    usages.each do |usage|
    #Array(usages.last).each do |usage|
      # set of past 24 hours
      past = Usage.all :conditions => ["site = ? AND period_from <= ? AND period_from > ?", 
                                        site, usage.period_from, (usage.period_from - 24.hours)]
      # delete free hours
      past.delete_if {|usage| usage.in_free_period? }
      # calc total
      total = past.inject(0) {|sum, usage| sum + usage.download }
      usage.update_attributes :download_24hr => total
    end
    usages.size
  end
  
  
end
