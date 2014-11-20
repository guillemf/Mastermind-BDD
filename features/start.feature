Feature: Board behaviour
  As a Player
  I want to see how the cells react to my taps as expected
  So I can begin playing

Scenario: Initial situation
  Given I am on the Initial Screen
  Then a new game should be ready
  
Scenario: Check color sequence
  Given I am on the Initial Screen
  When I select random positions
  And I tap 1 times on the random positions
  Then I should see a red circle at random position
  When I select random positions
  And I tap 2 times on the random positions
  Then I should see a yellow circle at random position
  When I select random positions
  And I tap 3 times on the random positions
  Then I should see a green circle at random position
  When I select random positions
  And I tap 4 times on the random positions
  Then I should see a blue circle at random position
	
Scenario: Create a combination
  Given I am on the Initial Screen
  When I tap 1 times on row 0 col 0
  Then I should see a red circle at row 0 col 0
  When I tap 2 times on row 0 col 1
  Then I should see a yellow circle at row 0 col 1
  When I tap 3 times on row 0 col 2
  Then I should see a green circle at row 0 col 2
  When I tap 4 times on row 0 col 3
  Then I should see a blue circle at row 0 col 3
  
#  Then I swipe left
#  And I wait until I don't see "Please swipe left"
#  And take picture


