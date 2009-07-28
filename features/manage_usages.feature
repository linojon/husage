Feature: Manage usages
  In order to ensure we dont go over the usage limit
  As a subscriber to Hughesnet
  I want to calculate my usage and be notified when reaching the limit
  
  Scenario: Refresh usage
    Given I am on the homepage
		When I press "Refresh usage"
    Then I should see "07/24/2009	15:00"

# get usages
# calculate totals
# paginate