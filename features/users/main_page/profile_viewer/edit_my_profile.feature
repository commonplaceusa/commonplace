Feature: Profile Editing

@wip
  Scenario: I am trying to edit my profile
    Give I see my profile
    When I click “edit my profile”
    Then I should see update my profile page
