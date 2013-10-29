# encoding: utf-8
Given /^I am logged in$/ do

  # be sure to use the right browser session
  Capybara.session_name = 'admin'

  # logout - just to be sure
  visit '/index.php?logout=true'
  visit '/'
  fill_in 'user', with: 'admin'
  fill_in 'password', with: "admin"
  click_button 'submit'
  #save_page
  find('#settings').click
  page.should have_selector('a#logout')
end

When /^I am in the "([^"]*)" app$/ do |app|
  visit "/index.php?app=#{app}"
  find('#settings').click
  page.should have_selector('a#logout')
end

When /^I go to "([^"]*)"$/ do |path|
  visit "#{path}"
  find('#settings').click
  page.should have_selector('a#logout')
end