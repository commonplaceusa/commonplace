Feature: Registration

Scenario: Trying to register
  Given a default community exists
  Given I am on the registration page
  When I click #user_sign_in
  Then I should see the sign in dropdown

@wip
  Scenario: Logging in from the drop-down
    Given I see the sign in dropdown
    And I fill in “Email Address”
    And I fill in “Enter your password”
    When I click “log in”
    Then I should see main page
@wip
  Scenario: Forgot Password from the drop-down
    Given I see the sign in dropdown
    When I click “Forgot Your Password”
    Then I should see the “Forgot Your Password” page
@wip
  Scenario: Forgot Password
    Given I see the “Forgot Your Password” page
    And I fill in “Email Address”
    When I click “Submit”
    Then I should be emailed a “Forgot Your Password” email
@wip
  Scenario: Facebook login from drop-down
    Given I see sign in drop down
    And I registered with Facebook
    When I click “Facebook login”
    Then I should go to the main page
@wip
  Scenario: I am on the second page of registration
    Given I am on the 2nd Registration Page
    And I Create a Password
    When I click Continue
    Then I should go to the third page

    Given I am on the 2nd Registration Page
    And I click “Upload a Photo”
    Then a select a photo box should pop up
    And I select a photo
    Then there should be a spinny gif
    Then it should say “Added a photo” with a check box

    Given I am on the 2nd Registration Page
    And I Uploaded a Photo
    When I select “Continue”
    Then the Crop Your Avatar Page should arrive

    Given I am on the Crop Your Avatar Page
    And I Cropped my Avatar
    When I click Continue
    Then the “Get Connected!” page should arrive
