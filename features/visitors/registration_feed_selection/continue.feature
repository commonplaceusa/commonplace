Feature: Selecting feeds as part of registration

@wip
  Scenario: I am registering and am selecting feeds
    Given I am on the Feed Selection Page
    And I Click Continue
    Then I should go to Next Registration Page
