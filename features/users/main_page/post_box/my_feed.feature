Feature: Wire feed

@wip
  Scenario: I am posting to a feed
    Given I see the expanded post box
    And I fill out post subject text field
    And I fill out post a message text field
    And I click category “Post to [my feed]”
    When I click “Post Now”
    Then wire should display [the correct post] in announcements
    And that [correct post] should be at the top of the wire
