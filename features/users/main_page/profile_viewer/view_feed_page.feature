Feature: Organization Feed Pages

@wip
  Scenario: I am trying to view an organization's feed page
    Given I see an organization profile
    When I click “View Feed Page”
    Then I should go to the feed page
