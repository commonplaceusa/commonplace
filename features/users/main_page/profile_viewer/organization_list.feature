Feature: Organization List

@wip
  Scenario: I am trying to view a list of organizations in my community
    Given I am on the main page
    When I click “organizations” on the profile viewer
    Then I should see a list of organizations
    And I should see the first neighbor’s profile
