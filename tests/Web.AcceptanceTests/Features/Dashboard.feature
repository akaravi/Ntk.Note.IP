@Dashboard
Feature: Dashboard

Scenario: Authenticated user sees dashboard statistics
    Given a logged in user on the dashboard
    Then dashboard statistics are visible

Scenario: Authenticated user exports dashboard CSV
    Given a logged in user on the dashboard
    When the user exports dashboard CSV
    Then the CSV export contains a header row
