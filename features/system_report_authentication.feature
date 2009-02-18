Feature: Report Authentication
  As a non Administrator
  I should not have access to any reports
  So they are protected from un authorized users

  Scenario: See the Reports link
    Given I am logged in as a User
    And I am on the home page

    Then I should not see "Reports"

  Scenario: View Report Overviews
    Given I am logged in as a User
    When I visit the "system report overview" page
    Then I should be denied access

  Scenario: Run Quickbooks Report
    Given I am logged in as a User
    When I visit the "quickbooks" page
    Then I should be denied access


