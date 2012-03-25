Feature: Sharing

@wip
  Scenario: I want to open the Share section of a post
    Given I am on the main page
    When I click “share”
    Then I should see the share section
    And “share” should be underlined
