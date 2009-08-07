Feature: Login
  In order to use the site
  I login
  So I can see my reports
  
  Scenario: Not logged in
    Given I am on the homepage
		Then I should see "Log-in"
		And I should see "Not Yet Registered?"

    Given I am on the usages report page
		Then I should see "Log-in"
		And I should see "Not Yet Registered?"
		
    Given I am on the original report page
		Then I should see "Log-in"
		And I should see "Not Yet Registered?"
		
    Given I am on the preferences page
		Then I should see "Log-in"
		And I should see "Not Yet Registered?"
	
		
	Scenario: Login error with site
		Given I am on the login page
		When I fill in "HughesNet Site ID" with "123"
		And I fill in "Password" with "secret"
		And I press "Log in"
		Then I should see "Site is not valid"

		
	Scenario: Login error with password
		Given there is an account for site "12345"
		And I am on the login page
		When I fill in "HughesNet Site ID" with "12345"
		And I fill in "Password" with "wrong"
		And I press "Log in"
		Then I should see "Password is not valid"


  Scenario: Forgot password

