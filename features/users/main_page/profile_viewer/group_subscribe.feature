Feature: Group Subscriptions

@wip
  Scenario: I am trying to subscribe to a discussion group
    Given I see a group profile
    When I click “Subscribe”
    Then I should be subscribed
    Then I should see “Unsubscribe?”
