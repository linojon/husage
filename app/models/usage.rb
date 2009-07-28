class Usage < ActiveRecord::Base
  
  require 'nokogiri'
  require 'open-uri'
  
  validates_uniqueness_of [:period_from]
  
  FREE_HOURS = (2...7)
  LEVEL_RED = 425
  LEVEL_ORANGE = 350
  
  def self.refresh
    #debugger
    report = fetch_hughes_report( '3BC44601' )
    parse_and_save_usages report
    calculate_24hour_totals
  end

  def self.delete_older_than( days )
    self.destroy_all ["period_from < ?", Time.now - days.days]
  end
  
  # def self.current_usage
  #   most_recent = Usage.first :order => 'period_from DESC'
  #   @usage = most_recent if most_recent.period_from.hour == Time.now.hour
  # end
  
  protected
  
  def self.fetch_hughes_report( siteid )
    # themonth in the format "2009 07"
    #debugger
    themonth = Time.now.strftime "%Y%%20%m"
    Nokogiri::HTML( open( "http://customercare.myhughesnet.com/act_usage.cfm?siteid=3BC44601&themonth=#{themonth}" ))
    #Nokogiri::HTML( open("http://localhost:3003/testdata/act_usage1.html"))
  end
  
  def self.parse_and_save_usages( report ) 
    rows = report.xpath("//div[@class='mainText']/following::table/tr")
    rows[3..-4].each do |row|
      #debugger
      tds = row.xpath("td")
      date, time_from, time_to, min_used, download, fap, upload = tds.collect {|td| td.content.gsub('\302\240','').strip }
      # puts [date, time_to, download].join(' | ')
      usage = Usage.create( :period_from => [date, time_from].join(' '), :min_used => min_used, 
        :download => download, :fap => fap, :upload => upload  )
      #puts usage.inspect
    end
  end
  
  def self.calculate_24hour_totals
    usages = Usage.all :conditions => { :download_24hr => nil }
    usages.each do |usage|
      past = Usage.all :conditions => 
        ["period_from <= ? AND period_from > ?", usage.period_from, usage.period_from - 24.hours]
      past.delete_if {|usage| FREE_HOURS.include? usage.period_from.hour }
      total = past.inject(0) {|sum, usage| sum + usage.download }
      usage.update_attributes :download_24hr => total
    end
  end
  
end
