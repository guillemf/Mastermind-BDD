Feature: Match sequence
  As a Player
  I want to play a full match
  So I can guess or fail the secret combination

Scenario: Winner situation
  Given I am on the Initial Screen
  When I guess the current combination at row 0
  Then I swipe left on row 0
  Then I should see a congratulations message
  Then I tap on new game
  Then I should be on the Initial Screen 
  
Scenario: Winner situation
  Given I am on the Initial Screen
  When I create a non winner combination at row 0
  Then I swipe left on row 0
  When I create a non winner combination at row 1
  Then I swipe left on row 1
  When I create a non winner combination at row 2
  Then I swipe left on row 2
  When I create a non winner combination at row 3
  Then I swipe left on row 3
  When I create a non winner combination at row 4
  Then I swipe left on row 4
  When I create a non winner combination at row 5
  Then I swipe left on row 5
  When I create a non winner combination at row 6
  Then I swipe left on row 6
  When I create a non winner combination at row 7
  Then I swipe left on row 7
  When I create a non winner combination at row 8
  Then I swipe left on row 8
  And I wait
  Then I should see a game lost message
  Then I tap on new game
  Then I should be on the Initial Screen