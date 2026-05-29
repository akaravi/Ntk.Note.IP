@IpLookup
Feature: IP lookup

Scenario: Root shows My IP on the lookup page
    Given a user visits the IP lookup page
    Then the My IP address is visible

Scenario: Manual lookup records address in browser history
    Given a user visits the IP lookup page
    When the user looks up "8.8.8.8"
    Then browser history contains "8.8.8.8"
