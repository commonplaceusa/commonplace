Feature: Nominating civic heroes

  @javascript
  Scenario: I want to nominate a civic hero
    Given a community
    Given I am on the nominate page
    When I fill in "Their Full Name" with "John Doe"
    And I fill in "Their Email Address" with "jdoe@gmail.com"
    And I fill in "Tell us why you are nominating this person." with "Because."
    And I fill in "Your Full Name" with "Jason Berlinsky"
    And I fill in "Your Email Address" with "jberlinsky@gmail.com"
    And I press "Nominate this person"
    And I wait for AJAX

    Then a new nomination should be created
    And I should see "Thanks for Nominating!"

