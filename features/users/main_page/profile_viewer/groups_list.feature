Feature: Groups List

@wip
  Scenario: I am trying to see a list of groups
    Given I am on the main page
    When I click “groups” on the profile viewer
    Then I should see a list of groups
