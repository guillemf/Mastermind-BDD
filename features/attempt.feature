Feature: Attempts
  As a Player
  I want to be able to add attempts in the match
  So I can guess the combination

Scenario: Check a combination missing first color
  Given I am on the Initial Screen
  When I tap 1 times on row 0 col 1
  When I tap 2 times on row 0 col 2
  When I tap 4 times on row 0 col 3
  Then I swipe left on row 0
  Then I should not see a result at row 0

Scenario: Check a combination missing second color
  Given I am on the Initial Screen
  When I tap 1 times on row 0 col 0
  When I tap 2 times on row 0 col 2
  When I tap 4 times on row 0 col 3
  Then I swipe left on row 0
  Then I should not see a result at row 0

Scenario: Check a combination missing third color
  Given I am on the Initial Screen
  When I tap 1 times on row 0 col 0
  When I tap 2 times on row 0 col 1
  When I tap 4 times on row 0 col 3
  Then I swipe left on row 0
  Then I should not see a result at row 0

Scenario: Check a combination missing fourth color
  Given I am on the Initial Screen
  When I tap 1 times on row 0 col 0
  When I tap 2 times on row 0 col 1
  When I tap 4 times on row 0 col 2
  Then I swipe left on row 0
  Then I should not see a result at row 0

Scenario: Check a complete combination
  Given I am on the Initial Screen
  When I create a random combination at row 0
  Then I swipe left on row 0
  Then I should see a result at row 0
  