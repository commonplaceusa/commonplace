Feature: Replying

@wip
  Scenario: I want to reply to a post
    Given I am on the main page
    When I click “reply”
    Then I should see the reply section
    And “reply” should be underlined
    And my cursor should be blinking in reply box
    And I should see the send button
