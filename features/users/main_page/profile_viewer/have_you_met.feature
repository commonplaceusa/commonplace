Feature: Met

@wip
  Scenario: I am trying to note that I have met another user
    Given I see neighbor’s profile
    When I click “Have you Met”
    Then a met should register in the database
    Then “You’ve Met!” should appear
