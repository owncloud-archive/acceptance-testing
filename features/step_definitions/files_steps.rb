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

Then /^I should see a list with the following files:$/ do |table|
  table.rows.each do |hash|
    #page.should have_content(hash[0])
    page.should have_content(hash[1])
    #page.should have_content(hash[2])
    page.should have_content(hash[3])
  end

  # table is a | httpd/unix-directory | Photos                                           | 784677   | 766.3 kB |pending
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
  page.execute_script("$('tr[data-file=\"#{entry}\"]').trigger('mouseover')")
end

Then /^I should see a "([^"]*)" action for ([^"]*)$/ do |action, entry|
  page.find(:xpath, "//tr[@data-file=\"#{entry}\"]").should have_content(action)
end

Then /^I should see a delete action for ([^"]*)$/ do |entry|
  page.should have_xpath("//tr[@data-file=\"#{entry}\"]//a[@original-title='Löschen']")
end

