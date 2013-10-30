# encoding: utf-8

Then(/^I should see a share with text input$/) do
  page.should have_css("#shareWith")
end

Given(/^I am sharing this ([^"]*) to user2$/) do  | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]").hover
  node = page.find(:xpath, "//tr[@data-file=\"#{filename}\"]")
  if not node.has_text?('Shared')
    page.find(:xpath, "//tr[@data-file=\"#{filename}\"]//a[@data-action=\"Share\"]").click
    fill_in "shareWith", :with => "user2"
    find('.ui-autocomplete').click
  end
end

Given(/^I go into the Shared Folder$/) do
  page.find(:xpath, "//tr[@data-file=\"Shared\"]").click
end

Then(/^I should see the shared ([^"]*)$/) do | filename |
  page.find(:xpath, "id('fileList')").should have_content(filename)
end

Then(/^I should see the share with user icon within ([^"]*)$/) do | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]").hover
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]").should have_content("Shared")
end

Then(/^I should see the username in the list of shared users within ([^"]*)$/) do | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]//a[@data-action=\"Share\"]").click
  page.should have_content "user2"
end

Then(/^I should not see the share with user icon within ([^"]*)$/) do | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]").should_not have_content("Shared")
end

When(/^And I click on the share file action of filename$/) do | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]//a[@data-action=\"Share\"]").click
end

When(/^In the share menu i hover over user2$/) do
  page.find(:xpath, "id('shareWithList')").hover
end

Then(/^I should see a "(.*?)" checkbox$/) do | action |
  page.find(:xpath, "id('shareWithList')").should have_content(action)
end

Then(/^I should see an unshare action$/) do
  page.should have_css(".unshare")
end

Then(/^I click on the unshare action$/) do
  page.find('.unshare').click
end

Then(/^I should not see the username in the list of shared users$/) do
  page.find(:xpath, "id('shareWithList')").should_not have_content('user2')
end