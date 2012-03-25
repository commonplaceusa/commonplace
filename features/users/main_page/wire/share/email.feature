Feature: Sharing

@wip
  Scenario: I want to email a post to a friend
    Given I am on the main page
    And that I clicked “Share” on a post
    When I click “Email”
    Then two boxes should be below that say “Email Address” and “Message” with a send button

    Given I see the email sharing option on the main page
    And I fill out an Email Address
    And I fill out a Message
    When I click “Send”
    Then an email should send
    And I should get a message that it sent
