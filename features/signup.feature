Feature: Signup
  In order to use the site
  I sign up
  So I can see my reports
  
 Scenario: Register
		Given I am on the homepage
		And I press "Register Now"
		Then I should be on the register page
		#And (show me)
		
		When I fill in "HughesNet Site ID" with "3BC44601"
		And I fill in "Email" with "linojon@gmail.com"
		And I fill in "Password" with "secret"
		And I fill in "Password confirmation" with "secret"
		And I press "Register"
		#And (show me)
		Then I should be on the first time setup page

	Scenario Outline: Registration field errors
		Given I am on the register page
		When I fill in "<FIELD>" with "<VALUE>"
		And I press "Register"
		Then I should see "<MESSAGE>"
		
		Examples:
		| FIELD | VALUE | MESSAGE |
		| HughesNet Site ID | 1 | Site is too short |
		| HughesNet Site ID | 123 456 | Site may only contain numbers and letters A-F |
		| HughesNet Site ID | 123z456 | Site may only contain numbers and letters A-F |
		| Email             | linoj   | Email should look like an email address |
		| Password          | x       | Password is too short |
		
		
	Scenario: Run setup
		Given I am on the register page
		When I fill in "HughesNet Site ID" with "3BC44601"
		And I fill in "Email" with "linojon@gmail.com"
		And I fill in "Password" with "secret"
		And I fill in "Password confirmation" with "secret"
		And I press "Register"
		#And (show me)
		Then I should be on the first time setup page

		When I press "Load and calculate first report"
		And (show me)
		Then I should see "Results for Site ID:"

	
	#Given a user is logged in as "3BC44601"
	