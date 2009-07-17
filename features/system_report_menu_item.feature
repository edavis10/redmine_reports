Feature: System Report Menu Item
  As an visitor
  I want to see a link to the Reports on the top menu
  So I access the reports easily

  Scenario: See the Reports link as a User
    Given I am logged in as a User
    And I am on the home page

    Then I should see "Reports"

  Scenario: See the Reports link as an anonymous User
    Given I am not logged in
    And I am on the home page

    Then I should not see "Reports"

