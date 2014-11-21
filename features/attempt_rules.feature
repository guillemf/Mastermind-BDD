Feature: Attempts
  As a Player
  I want to no attempt can be set if previous attempts are not checked
  So I can play attempts in order

Scenario: Check no attempt can start with previous attempt checked
  Given I am on the Initial Screen
  When I tap 1 times on row 1 col 0
  Then I should not see a red circle at row 1 col 0
