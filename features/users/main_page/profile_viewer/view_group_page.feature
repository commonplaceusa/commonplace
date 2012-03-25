Feature: Group Pages

@wip
  Scenario: I am trying to view a group's page
    Given I see an group profile
    When I click “View Group Page”
    Then I should go to the group page
