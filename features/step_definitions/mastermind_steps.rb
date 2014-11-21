@randomColumn = 0;
@randomRow = 0;

When(/^I have (\d+) rows in the screen$/) do |total|
  rows = query("MMCombinationRow")
  fail("The screen should contain #{total} rows but found #{rows.count} instead") if rows.count != total.to_i
end

When /^All rows are screen wide$/ do
  rows = query("MMCombinationRow")

  window = query("window")
  rows.each do |row|
    if row["frame"]["width"] != window.first["frame"]["width"]
       fail("All rows have to be as wide as the screen") 
    end
  end
end

When /^All rows are distributed along the screen$/ do
  rows = query("MMCombinationRow")
  
  lastFloor = 20
  rows.each do |row|
    if row["frame"]["y"] != lastFloor
       fail("Each row has to be after the previous one, expecting #{lastFloor}, #{row["frame"]["y"]} found") 
    end
    fail("All rows should be higher than zero") if row["frame"]["height"] == 0
    lastFloor = row["frame"]["y"] + row["frame"]["height"]
  end
end

When /^All rows are empty$/ do
  rows = query("MMCombinationRow")

  rows.each do |row|
    if row["label"] !~ /Combination Row \d:'    '/
       fail("All rows should be empty") 
    end
  end
end

Given /^I am on the Initial Screen$/ do
  # The screen should contain nine rows and five columns all being combinations
  macro "I have 9 rows in the screen"
  
  # Following the mock, those rows have to be as wide as the screen
  macro "All rows are screen wide"
  
  # Following the mock, the rows have distributed along the screen  
  macro "All rows are distributed along the screen"
  
  # All rows should be empty
  macro "All rows are empty"
  
end

Then(/^a new game should be ready$/) do
  rows = query("MMCombinationRow")

  rows.each do |row|
    
    combination = row["label"][18..23]
    fail("All rows combinations must be empty but #{combination} was found") if combination != "'    '"
  end

end

When(/^I tap (\d+) times on row (\d+) col (\d+)$/) do |number, row, col|
  repeat = number.to_i
  (0...repeat).each do
    touch "view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view {accessibilityLabel BEGINSWITH 'Cell #{col}'}"
  end
end

Then(/^I (should|should not) see a (red|yellow|green|blue) circle at row (\d+) col (\d+)$/) do |should_or_not, color, row, col|
  
  if should_or_not == "should"
    check_element_exists("view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view accessibilityLabel:'Cell #{col}:#{color}'")
  else
    check_element_does_not_exist("view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view accessibilityLabel:'Cell #{col}:#{color}'")
  end
  
end

When(/^I select random positions$/) do
  
  begin
    newRow =  (0..8).to_a.sample
    newColumn =  (0..3).to_a.sample
    cell = query("view {accessibilityLabel BEGINSWITH 'Combination Row #{newRow}'} child view accessibilityLabel:'Cell #{newColumn}:'")
  end until cell.count == 1
  @randomRow = newRow
  @randomColumn = newColumn

end

When(/^I tap (\d+) times on the random positions$/) do |number|
  macro "I tap #{number} times on row #{@randomRow} col #{@randomColumn}"
end

Then(/^I should see a (red|yellow|green|blue) circle at random position$/) do |color|
  macro "I should see a #{color} circle at row #{@randomRow} col #{@randomColumn}"
end

When(/^I create a random combination at row (\d+)$/) do |row|
  (0...4).each do |col|
    taps =  (1...4).to_a.sample
    (0...taps).each do
      touch "view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view {accessibilityLabel BEGINSWITH 'Cell #{col}'}"
    end
  end  
end

When(/^I create a non winner combination at row (\d+)$/) do |row|
  
  winnerCombination = backdoor("calabashBackdoor:", "")
  
  combination = ""

  loop do
    (0..4).each do
      combination += (1...4).to_a.sample.to_s
    end
    break if combination != winnerCombination
    combination = ""
  end
  
  (0...4).each do |col|
    taps =  combination[col].to_i
    (0...taps).each do
      touch "view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view {accessibilityLabel BEGINSWITH 'Cell #{col}'}"
    end
  end  
end


Then(/^I swipe left on row (\d+)$/) do |row|
  
  swipe :left, :query => "view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'}", force: :strong
  
end

Then(/^I (should|should not) see a result at row (\d+)$/) do |should_or_not, row|
    
  cells = query("view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view {accessibilityLabel BEGINSWITH 'Result'}")
    
  label = cells[0]["label"]  
  result = cells[0]["label"][8..12]

  if should_or_not == "should"
    fail("The result should be set at row #{row}") if result == nil
  else
    fail("The result should be set at row #{row}") if result
  end
  
end

When(/^I guess the current combination at row (\d+)$/) do |row|
  combination = backdoor("calabashBackdoor:", "").to_i
  
  (0...4).each do |col|
    divide = 10 ** (3-col)
    taps =  combination / divide
    combination = combination - (taps * divide)
    
    (0...taps).each do
      touch "view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view {accessibilityLabel BEGINSWITH 'Cell #{col}'}"
    end

  end  
  
end

Then(/^I should see a congratulations message$/) do
  
  # Test UIAlertView is there
  
  check_element_exists("view marked:'Winner!!!!'")
  check_element_exists("view marked:'You broke the code'")
  check_element_exists("view marked:'New Game'")
end

Then(/^I should see a game lost message$/) do
  # Test UIAlertView is there
  
  check_element_exists("view marked:'Game finished!!!!'")
  check_element_exists("view marked:'The code was too hard to break'")
  check_element_exists("view marked:'New Game'")
end

Then(/^I tap on new game$/) do
  touch "view marked:'New Game'"
end

Then(/^I should be on the Initial Screen$/) do
  macro "I am on the Initial Screen"
end
