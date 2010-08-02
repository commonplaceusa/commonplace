Feature: registration
  In order to use Commonplace
  As a User
  I want to register


  Scenario: Submit registration form
    Given I am on the home page
    When I fill in the following:
      | First Name            | Max                            |
      | Last Name             | Robespierre                    |
      | Email                 | max@example.com                |
      | Password              | secret                         |
      | Confirm Password      | secret                         |
      | Address               | 105 Winfield Way, Aptos, 95003 |
    And I check "I accept the privacy policy"
    And I press "Register!"
    Then I should see "Please include some information about yourself for the directory"
