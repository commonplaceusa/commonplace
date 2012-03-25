Feature: Sharing

@wip
  Scenario: I want to share a post via Twitter
    Given I am on the main page
    And that I clicked “Share” on a post
    When I click “Twitter”
    Then a twitter dialog box should pop up
