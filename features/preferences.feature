Feature: Preferences
  As a registered user on the site
  I change my preferences
  So the reports are more useful to me

	Scenario: test
		Given there is an account for site "12345" and I am logged in
		And I am on the homepage
		And (show me)
		When I follow "Preferences"
		Then I should be on the Preferences page
		And (show me)
		
	Scenario: Change thresholds
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		When I fill in "Warning threshold" with "200"
		And I fill in "Alert threshold" with "275"
		And I press "Update"
		#Then what?
		Then (show me)
	
	Scenario: Change email
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		When I fill in "Primary email address" with "foo@bar"
		And I press "Update"
		Then I should see "Email should look like an email address"
		#And (show me)
		When I fill in "Primary email address" with ""
		And I press "Update"
		Then I should see "Email is too short"
		#And (show me)
		When I fill in "Primary email address" with "foo@bar.com"
		And I press "Update"
		Then I should be on the Usages page
		#And (show me)
		
	Scenario: Other emails
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		When I fill in "Other emails" with "a@a.com,b@b.com,  c@c.com"
		And I press "Update"
		Then I should be on the Usages page
		When I go to the Preferences page
		Then the "Other emails" field should contain "a@a.com, b@b.com, c@c.com"
		#Then (show me)

		When I fill in "Other emails" with
			"""
			x@x.com
			y@y.com
			z@z.com
			"""
		And I press "Update"
		Then I should be on the Usages page
		When I go to the Preferences page
		Then the "Other emails" field should contain "x@x.com, y@y.com, z@z.com"
		Then (show me)
		
	Scenario: Invalid other emails
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		When I fill in "Other emails" with "a@a.com, b.com,  c@c.com"
		And I press "Update"
		And (show me)
		Then I should see "Other emails contains an invalid email address"
	
	Scenario: Change password
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		
		When I fill in "user_password" with "different"
		And I fill in "user_password_confirmation" with ""
		And I press "Update"
		Then I should see "Password doesn't match confirmation"

		When I fill in "user_password" with "different"
		And I fill in "user_password_confirmation" with "wrong"
		And I press "Update"
		Then I should see "Password doesn't match confirmation"

		# When I fill in "user_password" with ""
		# And I fill in "user_password_confirmation" with "different"
		# And I press "Update"
		# Then I should see "Password doesn't match confirmation"
		
		When I fill in "user_password" with "different"
		And I fill in "user_password_confirmation" with "different"
		And I press "Update"
		Then I should be on the Usages page
		
		When I follow "Log out"
		When I fill in "HughesNet Site ID" with "12345"
		And I fill in "Password" with "secret"
		And I press "Log in"
		Then I should see "Password is not valid"
		#And (show me)

		When I fill in "HughesNet Site ID" with "12345"
		And I fill in "Password" with "different"
		And I press "Log in"
		Then I should be on the Usages page
		

	Scenario: Delete account
		Given there is an account for site "12345" and I am logged in
		And I am on the Preferences page
		When I press "Delete This Report"
		#And (show me)
		Then I should see "Husage reports and login deleted for 12345"
		
		When I fill in "HughesNet Site ID" with "12345"
		And I fill in "Password" with "secret"
		And I press "Log in"
		Then I should see "Site is not valid"
		
	
	
	