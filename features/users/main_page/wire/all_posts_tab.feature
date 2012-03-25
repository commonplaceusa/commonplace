Feature: All Posts Tab

@wip
  Scenario: I want ti view an assortment of posts
    Given I am on the main page
    When I click “all posts” tab
    Then I should see three announcements
    And I should see three offers
    And I should see three requests
    And I should see three neighborly news items
    And I should see three events
    And I should see three meet-ups
