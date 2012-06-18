Feature: Registration

  @javascript
    Scenario: Trying to register
      Given a default community exists
      Given I am on the registration page
      When I click #sign_in_button
      Then I should see the sign in dropdown
      And I should see the selector .forgot

      When I fill in email with "test@example.com"
      And I fill in password with "password"
      When I click input.submit
      Then I should see the main page

@wip @javascript
    Scenario: Forgot Password from the drop-down
      Given I see the sign-in drop-down
      When I click .forgot
      Then I should be on the Forgot Password page

      #When I fill in email_address with "test@example.com"
      #And I click input.submit
      #Then a Forgot Password email should have sent to "test@example.com"
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
