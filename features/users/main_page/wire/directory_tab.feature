Feature: Directory Tab

@wip
  Scenario: I want to see the directory of neighbors
    Given I am on the main page
    When I click “directory” tab
    Then I should see a listing of one hundred users
