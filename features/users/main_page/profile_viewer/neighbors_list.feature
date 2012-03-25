Feature: Neighbors List

@wip
  Scenario: I am trying to view a list of my neighbors
    Given I am on the main page
    When I click “neighbors” on the profile viewer
    Then I should see a list of neighbors
    And I should see the first neighbor’s profile
