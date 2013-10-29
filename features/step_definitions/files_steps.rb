# encoding: utf-8
Given /^I have uploaded the "([^"]*)" files?$/ do |file_set|
  path= File.join(File.dirname(File.expand_path(__FILE__)), "../../test-data/#{file_set}/*")
  Dir.glob(path) do |file|
    if not page.has_content?(File.basename(file))
      attach_file 'files[]', file
    end
    # below is necessary for non-selenium
    #page.find('.file_upload_filename').click
  end
end

Then /^([^"]*) should be of type ([^"]*)$/ do |name, mime|
    page.should have_xpath("//tr[@data-file=\"#{name}\" and @data-mime=\"#{mime}\"]")
end

Then /^([^"]*) should have ([^"]*) bytes size$/ do |name, bytes|
    page.should have_xpath("//tr[@data-file=\"#{name}\" and @data-size=\"#{bytes}\"]")
end

Then /^([^"]*) should show a ([^"]*) size$/ do |name, human|
    page.should have_xpath("//tr[@data-file=\"#{name}\"]//td[@title=\"#{human}\"]")
end

When /^I should see a new button$/ do
  page.should have_selector('div#new.button')
end

When /^I should see an upload action$/ do
  page.should have_selector('form.file_upload_form')
end

When /^I hover over ([^"]*)$/ do |entry|
  page.find(:xpath, "//tr[@data-file=\"#{entry}\"]").hover
end

Then /^I should see a "([^"]*)" action for ([^"]*)$/ do |action, entry|
  page.find(:xpath, "//tr[@data-file=\"#{entry}\"]").should have_content(action)
end

Then /^I should see a delete action for ([^"]*)$/ do |entry|
  page.should have_xpath("//tr[@data-file='#{entry}']")
end

When(/^I click on the new button$/) do
    page.find('#new').click
end

#@my_action need refactoring
When(/^I click on the new ([^"]*) action$/) do | action |
    page.find(:xpath, "//li[@data-type=\"#{action}\"]").click
    @my_action = action
end

When(/^I enter the filename ([^"]*)$/) do | filename |
    #"\n" sends a :return
    page.find(:xpath, "//li[@data-type=\"#{@my_action}\"]/form/input").set filename + "\n"
end

Then(/^I should see the file ([^"]*)$/) do | filename |
  page.find(:xpath, "//tr[@data-file=\"#{filename}\"]").should have_content(filename)
end

Given(/^I go to \/$/) do
    visit "/"
end

When(/^I click on the ([^"]*) action of ([^"]*)$/) do | action, filename |
    page.find(:xpath, "//tr[@data-file=\"#{filename}\"]//a[@data-action=\"#{action}\"]").click
end

Then(/^I should download ([^"]*)$/) do | file |
    # TODO have not found better escape function
    file_escaped = URI::escape(file)
    print page.response_headers['Content-Disposition']
    page.response_headers['Content-Disposition'].should have_content("filename=\"#{file_escaped}\"")
end

When(/^Click the delete cross of ([^"]*)$/) do | filename |
    find('.delete').click
end

Then(/^I should no longer see ([^"]*)$/) do |filename|
    page.should_not have_xpath("//tr[@data-file=\"#{filename}\"]")
end

Then(/^There should be ([^"]*)$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^Not anymore the file ([^"]*)$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I type in ([^"]*)$/) do
  pending # express the regexp above with the code you wish you had
end

#When(/^I click on the "(.*?)" action of ([^"]*)$/) do |action, filename|
#  pending # express the regexp above with the code you wish you had
#end