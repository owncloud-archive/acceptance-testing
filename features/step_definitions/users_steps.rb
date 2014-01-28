# encoding: utf-8
Given /^user "(.*?)" does not exist$/ do |name|
	# TODO: remove user if exists ?
    #page.should_not have_xpath("//tr[@data-uid=\"#{name}\"]")
end

Given /^user "(.*?)" exists$/ do |name|
	# TODO: auto-create user if exists ?
    #page.should have_xpath("//tr[@data-uid=\"#{name}\"]")
end

Given /^group "(.*?)" exists$/ do |name|
	# TODO: auto-create group if exists ?
end

Given(/^user "(.*?)" is in group "(.*?)"$/) do |arg1, arg2|
	# TODO
end

Then /^the list shows a user "(.*?)"$/ do |name|
    page.should have_xpath("//tr[@data-uid=\"#{name}\"]")
end

Then /^the list does not show a user "(.*?)"$/ do |name|
    page.should_not have_xpath("//tr[@data-uid=\"#{name}\"]")
end

Then /^user "(.*?)" should have the full name "(.*?)"$/ do |name, fullname|
    page.should have_xpath("//tr[@data-uid=\"#{name}\" and @data-displayname=\"#{fullname}\"]")
end

Then /^user "(.*?)" (should|should not) be in group "(.*?)"$/ do |name, maybe, group|
	groupsSelect = page.find("tr[data-uid=\"#{name}\"]")
	# TODO: maybe replace this with "click on select and check entries"
	groupsSelect = groupsSelect.find(".groupsselect", :visible => false)
	actualGroups = groupsSelect["data-user-groups"]
	actualGroups = actualGroups[1, actualGroups.length - 2].split(',')
	if group == ''
		if maybe == 'should'
			actualGroups.length.should == 0
		else
			actualGroups.length.should_not == 0
		end
	else
		if maybe == 'should' then
			actualGroups.should include('"' + group + '"')
		else
			actualGroups.should_not include('"' + group + '"')
		end
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

When(/^I click delete for user "(.*?)"$/) do |user|
	userEl = find(:css, "tr[data-uid=\"#{user}\"]")
    userEl.hover
	userEl.find(:css, ".action.delete").click
	# refresh browser page to commit
	driver.refresh()
end

When(/^I change the full name of user "(.*?)" to "(.*?)"$/) do |user, fullname|
	within "tr[data-uid=\"#{user}\"]" do
		actionEl = find(:css, ".displayName")
		actionEl.hover
		actionEl.find(:css, "img").click
		actionEl.find(:css, "input").set(fullname)
	end
	# blur
	page.find("body").click
end

When(/^I add user "(.*?)" to group "(.*?)"$/) do |user, group|
	within "tr[data-uid=\"#{user}\"]" do
		actionEl = find(:css, ".groups")
		# open select box
		actionEl.find(:css, ".multiselect").click
		# unfortunately no data tags to easily find checkbox
		actionEl.find(:css, "label", :text => group).find(:xpath, "..").find(:css, "input").set(true)
	end
	# blur
	page.find("body").click
end

When(/^I remove user "(.*?)" from group "(.*?)"$/) do |user, group|
	within "tr[data-uid=\"#{user}\"]" do
		actionEl = find(:css, ".groups")
		# open select box
		actionEl.find(:css, ".multiselect").click
		# unfortunately no data tags to easily find checkbox
		actionEl.find(:css, "label", :text => group).find(:xpath, "..").find(:css, "input").set(false)
	end
	# blur
	page.find("body").click
end

