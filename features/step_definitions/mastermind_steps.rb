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
  
  lastFloor = 0
  rows.each do |row|
    if row["frame"]["y"] != lastFloor
       fail("Each row has to be after the previous one, expecting #{lastFloor}, #{row["frame"]["y"]} found") 
    end
    fail("All rows should be higher than zero") if row["frame"]["height"] == 0
    lastFloor = row["frame"]["y"] + row["frame"]["height"]
  end
end

Given /^I am on the Initial Screen$/ do
  # The screen should contain nine rows and five columns all being combinations
  macro "I have 9 rows in the screen"
  
  # Following the mock, those rows have to be as wide as the screen
  macro "All rows are screen wide"
  
  # Following the mock, the rows have distributed along the screen  
  macro "All rows are distributed along the screen"
  
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

Then(/^I should see a (red|yellow|green|blue) circle at row (\d+) col (\d+)$/) do |color, row, col|
  check_element_exists("view {accessibilityLabel BEGINSWITH 'Combination Row #{row}'} child view accessibilityLabel:'Cell #{col}:#{color}'")
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
