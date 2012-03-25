Feature: Service Publicity Posts

@wip
  Scenario: I am trying to publicize a service to my neighbors
    Given I see the expanded post box
    And I fill out post subject text field
    And I fill out post a message text field
    And I click category “Propose a meet-up”
    When I click “Post Now”
    Then wire should display [the correct post] in announcements
    And that [correct post] should be at the top of the wire
