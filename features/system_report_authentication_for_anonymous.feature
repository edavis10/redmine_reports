Feature: Report Authentication for anonymous users
  As an anonymous user
  I should not have access to any reports
  So they are protected from un-authorized users

  Scenario: See the Reports link
    Given I am not logged in
    And I am on the home page

    Then I should not see "Reports"

  Scenario: View Report Overviews
    Given I am not logged in
    When I visit the "system report overview" page
    Then I should go to the login page

  Scenario: Run Quickbooks Report
    Given I am not logged in
    When I visit the "quickbooks" page
    Then I should go to the login page


