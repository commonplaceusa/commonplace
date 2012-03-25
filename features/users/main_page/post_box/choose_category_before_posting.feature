Feature: Posting

@wip
  Scenario: Trying to make a post
    Given I see expanded post box
    And I fill out post subject text field
    And I fill out post a message text field
    When I click “Post Now”
    Then I should see “choose a category before posting!”
