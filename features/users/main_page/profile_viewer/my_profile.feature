Feature: Profile

@wip
  Scenario: I am trying to view my profile
    Given I am on the main page
    When I click “my profile” on the profile viewer
    Then I should see my profile
