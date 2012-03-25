Feature: Announcements Tab

@wip
  Scenario: I want to view announcements on the wire
    Given I am on the main page
    When I click “organization announcements” tab
    Then I should see organization announcement posts
    And they should be in reverse chronological order
