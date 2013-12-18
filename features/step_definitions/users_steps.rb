# encoding: utf-8
Then /^the list shows a user "(.*?)"$/ do |name|
    page.should have_xpath("//tr[@data-uid=\"#{name}\"]")
end

Then /^user "(.*?)" should have the full name "(.*?)"$/ do |name, fullname|
    page.should have_xpath("//tr[@data-uid=\"#{name}\" and @data-displayname=\"#{fullname}\"]")
end

Then /^user "(.*?)" should be in group "(.*?)"$/ do |name, group|
	groupsSelect = page.find("tr[data-uid=\"#{name}\"]")
	# TODO: maybe replace this with "click on select and check entries"
	groupsSelect = groupsSelect.find(".groupsselect", :visible => false)
	if group != ''
		groupsSelect['data-user-groups'].should == "[\"#{group}\"]"
	else
		groupsSelect['data-user-groups'].should == "[]"
	end
end

Then /^I should see a create user form$/ do
	page.should have_selector("form#newuser")
end

When(/^I fill the user form with "(.*?)" and "(.*?)"$/) do |user, password|
	within '#newuser' do
		fill_in 'newusername', with: user
		fill_in 'newuserpassword', with: password
	end
end

When(/^I click create user$/) do ||
	within '#newuser' do
		# button has no ID nor name !?
		#click_button 'submit'
  		find(:css, "input[type=submit]").click
	end
end

