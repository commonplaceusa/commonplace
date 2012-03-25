Feature: Big registration page

@wip
  Scenario: I am trying to register
    Given I am on the registration page
    When I click the “Learn More” button
    Then I should go to the Learn More page

    Given I am on the registration page
    When I fill in “Name”
    And I fill in “Email”
    And I fill in “Street Address”
    And I Click “Sign Me Up!”
    Then I should go to the second page

    Given I am on the registration page
    When I click “connect with facebook”
    Then the Facebook connect box should show up

    Given I am on the Facebook connect box
    When I finish filling it out and connect
    Then I should go to the “Give us your street address and cahnge your name if you want” Page
