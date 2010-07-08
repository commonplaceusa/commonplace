Feature: posting
  In order to communicate with my community
  As a user
  I want to create a post

  Scenario: Create a post
    Given I am logged in
    And I am on the home page
    When I fill in "post_body" with "Anybody have a ladder?"
    And I press "Post"
    Then I should be on the home page


