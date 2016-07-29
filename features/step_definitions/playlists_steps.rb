Given(/^I am on the new playlist page$/) do
  visit new_playlist_path
end

When(/^I set the number of tracks to (\d+)$/) do |limit|
  find_by_id('limit').set limit

end

When(/^I set the minimum song popularity to (\d+)$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I provide "([^"]*)" as a track URI$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^a playlist is created$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the view playlist page is loaded$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
