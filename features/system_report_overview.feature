Feature: Report Overview
  As an visitor
  I want to see a list of reports
  So I can check them easily

  Scenario: See the Reports link
    Given I am logged in as a User
    And I am on the homepage

    Then I should see "Reports"

  Scenario: See the Reports link
    Given I am not logged in
    And I am on the homepage

    Then I should not see "Reports"

  Scenario: View Report Overviews as anonymous user
    Given I am not logged in
    When I visit the "system report overview" page
    Then I should go to the login page


  Scenario: See a list of reports
    Given I am logged in as a User
    And I am on the system report overview page

    Then I should see "Reports"
    And I should see a menu called "reports-menu"
