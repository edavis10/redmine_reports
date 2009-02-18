Feature: Report Overview
  As an Administrator
  I want to see a list of reports
  So I can check them easily

  Scenario: See a list of reports
    Given I am logged in as an Administrator
    And I am on the system report overview page

    Then I should see "Reports"
    And I should see a list called "reports"
