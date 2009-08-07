# Given /^the following usages:$/ do |usages|
#   Usage.create!(usages.hashes)
# end
# 
# When /^I delete the (\d+)(?:st|nd|rd|th) usage$/ do |pos|
#   visit usages_url
#   within("table > tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end
# 
# Then /^I should see the following usages:$/ do |usages|
#   usages.rows.each_with_index do |row, i|
#     row.each_with_index do |cell, j|
#       response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
#         td.inner_text.should == cell
#       }
#     end
#   end
# end

Given /^there is an account for site "(.*)"$/ do |site|
  @current_user = User.create!(
    :site => site,
    :password => 'secret',
    :password_confirmation => 'secret',
    :email => "#{site}@example.com"
  )
end

Given /^I am logged in as "(.*)"$/ do |login|
  @current_user = User.create!(
    :site => login,
    :password => 'secret',
    :password_confirmation => 'secret',
    :email => "#{login}@example.com"
  )
  # @current_user.activate! 
  visit "/login" 
  fill_in("HughesNet Site ID", :with => login) 
  fill_in("password", :with => 'secret') 
  click_button("Log in")
  #response.body.should =~ /Logged/m  
end

Given /^there is an account for site "(.*)" and I am logged in$/ do |site|
  Given "I am logged in as \"#{site}\""
  report = Nokogiri::HTML( open( "spec/fixtures/act_usage.html" ))
  Usage.parse_and_save_usages site, report
  Usage.calculate_24hour_totals site
end


Then /^\(show me\)$/ do
  save_and_open_page
end

# ========================
# webrat steps add

When /^I fill in "([^\"]*)" with$/ do |field, value|
  fill_in(field, :with => value) 
end
