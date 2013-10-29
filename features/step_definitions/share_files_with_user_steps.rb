# encoding: utf-8

Then(/^I should see a share with text input$/) do
  page.should have_css("#shareWith")
end

Given(/^I am sharing this file to user1$/) do
  file = "Demo Movie OGG - Big Bug Bunny Trailer.ogg"
  page.find(:xpath, "//tr[@data-file=\"#{file}\"]").hover
  page.find(:xpath, "//tr[@data-file=\"#{file}\"]//a[@data-action=\"Share\"]").click
  fill_in "shareWith", :with => "user2"
  find('.ui-autocomplete').click
end

Then(/^I should see the share with user icon$/) do
  page.should have_content "Shared"
end

Then(/^I should see the username in the list of shared users$/) do
  file = "Demo Movie OGG - Big Bug Bunny Trailer.ogg"
  page.find(:xpath, "//tr[@data-file=\"#{file}\"]//a[@data-action=\"Share\"]").click
  page.should have_content "user2"
end