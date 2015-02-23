Feature: Typical Flows
  As an SDK developer
  I want to have some typical flows
  so I know if changes I make break basic functionality

  Background:
    Given I launch the sample application

  Scenario: Register with invoice and buy
    When I press 'Buy 1 ticket'
    And I complete the registration process
    Then I should see a QR code for the ticket I bought
