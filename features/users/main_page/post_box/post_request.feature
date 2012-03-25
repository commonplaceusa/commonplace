Feature: Request Posts

@wip
  Scenario: I am trying to request something from my neighbors
    Given I see the expanded post box
    And I fill out post subject text field
    And I fill out post a message text field
    And I click category “Post a Request”
    When I click “Post Now”
    Then wire should display [the correct post] in a request category
    And that [correct post] should be at the top of the wire
