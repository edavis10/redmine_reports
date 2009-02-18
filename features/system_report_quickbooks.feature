Feature: Quickbooks Report
  As an Administrator
  I want to see reports on Quickbooks and other financial data
  So I can make financial decisions

  Scenario: See link to the Quickbooks report
    Given I am logged in as an Administrator
    And I am on the system report overview page

    Then I should see "Reports"
    And I should see a link "Quickbooks"

  Scenario: Open link to the Quickbooks report
    Given I am logged in as an Administrator
    And I am on the system report overview page

    When I follow "Quickbooks"

    Then I should be on the "quickbooks" page

