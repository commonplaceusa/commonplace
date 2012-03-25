Feature: Drop-Down Account Controls

@wip
  Scenario: I want to modify my account settings
    Given I am on the main page
    When I hover over “HI, [Name]”
    Then a dropdown should appear

    Given I see the account drop down
    When I click Accoutn Settings
    Then I should be taken to the account settings page

@wip
  Scenario: I want to navigate the site via the drop-down
    Given I see the main page
    When I click Inbox
    Then I should be taken to the Inbox Page

    Given I see the main page
    When I click Invite
    Then I should be taken to the Invite Page
