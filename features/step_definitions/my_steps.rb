Given /^I am not logged in$/ do
  visit '/index.php?logout=true'
end

When /^I enter my valid credential$/ do
  visit '/'
  fill_in 'user', with: 'admin'
  fill_in 'password', with: 'admin'
  click_button 'submit'
end

Then /^I should be able to access my cloud$/ do
  visit '/'
  find('#settings').click
  page.should have_selector('a#logout')
end
