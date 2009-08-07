module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
    when /the usages report page/
      usages_path

    when /the original report page/
      original_path

    when /the preferences page/
      preferences_path
      
    when /the register page/
      new_user_path
      
    when /the first time setup page/
      setup_path
      
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /^the (.*) page$/i
      '/'+$1.downcase
      
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
      
    end
  end
end

World(NavigationHelpers)
