Feature: Events Tab

@wip
  Scenario: I want to view events
    Given I am on the main page
    When I click “events” tab
    Then I should see events posts
    And they should display the one coming up soonest first
