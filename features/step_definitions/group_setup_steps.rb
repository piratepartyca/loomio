Given(/^I complete the group setup wizard$/) do
  step "I click the \"next\" button"
  step 'I fill in the group panel'
  step "I click the \"next\" button"
  click_on 'Goto group'
end

Then(/^the group should be setup$/) do
  @group.reload
  @group.discussions.first.title.should == I18n.t('example_discussion.title')
  @group.motions.first.name.should == I18n.t('example_motion.name')
  @group.is_setup?.should be_true
end

Then(/^I should be on the group page$/) do
  pending # express the regexp above with the code you wish you had
end

Given /^I visit the group setup wizard for that group$/ do
  visit setup_group_path(@group.id)
end

Given /^the users time-zone has been set$/ do
  @user.update_attribute(:time_zone, "Auckland")
end

Given(/^I fill in the form up to the next_steps tab$/) do
  step "I click the \"next\" button"
  step 'I fill in the group panel'
  step "I click the \"next\" button"
end

When(/^I fill in the group name$/) do
  @group_name = "Fantastic Spinners"
  fill_in 'Group name', with: @group_name
end

When(/^a group is already setup$/) do
  @group.setup_completed_at = Time.now
  @group.save!
end

When /^I click Goto group$/ do
  click_on 'Goto group'
end

When /^I click the "(.*?)" button$/ do |id|
  find("##{id}").click
end

When /^I fill in the group panel$/ do
  fill_in 'group_description', with: "A discription of my group"
end

Then /^I should see the setup group tab$/ do
  find('.tab-content').should have_css('#group-tab.active')
end

Then /^I should see the setup intro tab$/ do
  find('.tab-content').should have_css('#intro-tab.active')
end

Then /^I should see the setup invites tab$/ do
  find('.tab-content').should have_css('#invite-tab.active')
end

Then /^the group should have an example discussion$/ do
  @group.discussions.count.should == 1
end

Given(/^the example discussion should have a decision$/) do
  @group.motions.count.should == 1
end

Then /^I should see the group page$/ do
  find('.group-title').should have_content(@group.name)
end

Then(/^I should see my time zone set in the timezone select$/) do
  find('#group_setup_close_at_time_zone').value.should ==  "Auckland"
end

Then(/^I should be told that I dont have permission to set up this group$/) do
  page.should have_content(I18n.t('error.not_permitted_to_setup_group'))
end

Then(/^the date the group was setup is stored$/) do
  @group_setup.group.setup_completed_at.should_not be_nil
end

Then(/^I should be redirected to the group page$/) do
  page.should have_css('.groups.show')
end

Then /^I should see the group setup wizard$/ do
  page.should have_content('Set up your group')
end

