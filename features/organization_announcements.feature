Feature: announcement management
  In order to inform customers/interested people
  As an organization manager
  I want to manage announcements about my organization

  Scenario: Create an announcement
    Given I am logged in
    And an organization exists
    And I am on the organization's page
    When I fill in the following:
    | Announcement Title       | Free stuff!                   |
    | Announcement Description | Lots of food and stuff, free. |
    And I press "Announce"
    Then an announcement should exist with title: "Free stuff!"
    And the announcement should be in the organization's announcements
