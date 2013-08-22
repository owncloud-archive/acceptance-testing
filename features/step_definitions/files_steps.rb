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
  #element = page.find('tr', :text => entry)
  #Capybara.current_session.driver.mouse.move_to(element).perform
  #page.execute_script("$('tr[data-file=\"#{entry}\"]').trigger('mouseover')")
  find("tr[@data-file=\"#{entry}\"]")
end

Then /^I should see a "([^"]*)" action for ([^"]*)$/ do |action, entry|
  page.find(:xpath, "//tr[@data-file=\"#{entry}\"]").should have_content(action)
  print #{action}
end

Then /^I should see a delete action for ([^"]*)$/ do |entry|
  page.should have_xpath("//tr[@data-file='#{entry}']")
end

