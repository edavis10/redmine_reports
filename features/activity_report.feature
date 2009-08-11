Feature: Activity Report
  As a User
  I want to see reports on the activities of users
  So I can see what people are doing

  Scenario: See link to the Activity report
    Given I am logged in as a user with permission to "run activity report"
    And I am on the system report overview page

    Then I should see "Reports"
    And I should see a link "Activity Report"

  Scenario: Open link to the Activity report
    Given I am logged in as a user with permission to "run activity report"
    And I am on the system report overview page

    When I follow "Activity Report"

    Then I am on the "activity report" page

  Scenario: Activity Report Report as normal user
    Given I am logged in as a User
    When I visit the "activity report" page
    Then I should be denied access

  Scenario: Completion Count Report as an anonymous user
    Given I am not logged in
    When I visit the "activity report" page
    Then I should go to the login page

  Scenario: Report form
    Given I am logged in as a user with permission to "run activity report"
    When I visit the "activity report" page

    Then I should see "Activity Report"
    And I should see "Start"
    And I should see "End date"

  Scenario: Run report
    Given I am logged in as a user with permission to "run activity report"
    When I visit the "activity report" page
    And I select some valid values for the "activity" report
    And I press "Apply"

    Then I see the activity report for each user

 