Feature: Event Posting

@wip
  Scenario: Trying to post an event
    Given I click the category “Post an event”
    And I fill out post subject text field
    And I fill out discription of your event field
    And I fill out event date
    And I label this post
    When I click “post your event”
    Then wire should display [the correct post] in events
    And that event should be posted on [the correct groups] page
