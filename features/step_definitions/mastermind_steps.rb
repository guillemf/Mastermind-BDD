@randomColumn = 0;
@randomRow = 0;

Given /^I am on the Initial Screen$/ do
  # The screen should contain nine rows and five columns
  rows = query("view {accessibilityLabel BEGINSWITH 'Combination Row'}")
  fail("The screen should contain nine rows") if rows.count != 9
  
  # Following the mock, those rows have to be as wide as the screen
  window = query("window")
  rows.each do |row|
    if row["frame"]["width"] != window.first["frame"]["width"]
       fail("All rows have to be as wide as the screen") 
    end
  end
  # Following the mock, the rows have distributed along the screen  
  lastFloor = 0
  rows.each do |row|
    if row["frame"]["y"] != lastFloor
       fail("Each row has to be after the previous one, expecting #{lastFloor}, #{row["frame"]["y"]} found") 
    end
    fail("All rows should be higher than zero") if row["frame"]["height"] == 0
    lastFloor = row["frame"]["y"] + row["frame"]["height"]
  end
  
  # All rows are combination
  rows.each do |row|
    fail("All rows must be combination rows but #{row["class"]} was found") if row["class"] != "MMCombinationRow"
  end
  
  sleep(STEP_PAUSE)
end

Then(/^a new game should be ready$/) do
  rows = query("view {accessibilityLabel BEGINSWITH 'Combination Row'}")

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
