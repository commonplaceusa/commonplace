Feature: News Posts

@wip
  Scenario: I am trying to post news to my neighborhood
    Given I see the expanded post box
    And I fill out post subject text field
    And I fill out post a message text field
    And I click category “Post Neighborly News”
    When I click “Post Now”
    Then wire should display [the correct post] in the neighborly news category
    And that [correct post] should be at the top of the wire
