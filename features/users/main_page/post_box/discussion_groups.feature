Feature: Discussion Groups

@wip
  Scenario: Trying to navigate to a discussion group
    Given I am on the main page
    When I click discussion groups on the post box
    Then I should see the list of discussion groups

    Given I see the list of discussion groups
    When I click a discussion group listing
    Then I should go to the [correct discussion group] page
