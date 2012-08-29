Given /^I am logged in$/ do

  # be sure to use the right browser session
  Capybara.session_name = 'admin'

  # logout - just to be sure
  visit '/index.php?logout=true'
  visit '/'
  fill_in :user, with: 'admin'
  fill_in :password, with: 'admin'
  click_button 'submit'
end
