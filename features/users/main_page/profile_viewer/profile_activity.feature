Feature: Profile Activity History

@wip
  Scenario: I am trying to use a neighbor's profile history
    Given I see a neighbor’s profile
    When I click an activity link
    Then I should see the correct post in the wire
    And the neighbor’s name should be highlighted on the post
