Feature: registration
  In order to use Commonplace
  As a User
  I want to register


  Scenario: Get to registration from the home page
    Given I am on the home page
    When I follow "Register"
    Then I should be on the new account page

  Scenario: Start registration with code from the home page
    Given I am on the home page
    And I fill in "account_code" with "Rox!"
    When I submit the "code" form
    Then I should be on the new account page
    And I should see "Welcome to Roxbury"

  Scenario: Submit registration form
    Given I am on the new account page
    When I fill in the following:
      | First Name            | Max                            |
      | Last Name             | Robespierre                    |
      | Email                 | max@example.com                |
      | Password              | secret                         |
      | Password Confirmation | secret                         |
      | Street Address        | 105 Winfield Way, Aptos, 95003 |
      | Registration Code     | Rox!                           |
    And I check "I accept the privacy policy"
    And I press "Register!"
    Then I should see "Please include some information about yourself for the directory"
