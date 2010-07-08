Feature: event management
  In order to inform customers/interested people
  As an organization manager
  I want to manage events my organization is supporting

  Scenario: Create an event
    Given I am logged in
    And an organization exists
    And I am on the organization's page
    When I fill in "Event Title" with "Sale!"
    And I fill in the following:
    | Event Title       | Sale!               |
    | Event Description | We're selling stuff |
    | Event Date        | 2020-11-01          |
    And I press "Submit"
    Then an event should exist with title: "Sale!"
    And the event should be in the organization's events
