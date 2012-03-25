Feature: Neighborhood Post Tab

@wip
  Scenario: I want to view neighborhood posts
    Given I am on the main page
    When I click “neighborhood posts” tab
    Then I should see neighborhood posts
    And they should be in reverse chronological order
