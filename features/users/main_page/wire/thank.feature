Feature: Thanks

@wip
  Scenario: I want to thank a user for a post
    Given I am on the main page
    When I click “thank” button
    Then I should see “thanked!”
    And I should see a list of thanks
    And I should see an increase in number of people who have thanked poster
