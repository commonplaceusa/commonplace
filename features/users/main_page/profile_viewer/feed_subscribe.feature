Feature: Feed Subscriptions

@wip
  Scenario: I am trying to subscribe to a feed
    Given I see an organization profile
    When I click “Subscribe”
    Then I should be subscribed
    Then I should see “Unsubscribe?”
