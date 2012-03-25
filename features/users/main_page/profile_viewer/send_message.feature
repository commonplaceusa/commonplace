Feature: Messaging

@wip
  Scenario: I am trying to send a message to a neighbor
    Given I see a neighbor’s profile
    When I click “Send a Message”
    Then the send a message box should pop up
