Feature: Sharing

@wip
  Scenario: I am trying to share a post via Facebook
    Given I am on the main page
    And that I clicked “Share” on a post
    When I click “Facebook”
    Then a facebook dialog box should pop up
