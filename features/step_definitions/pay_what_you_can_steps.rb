Given(/^I am on the pay what you can page$/) do
  visit contributions_path
end

Given(/^my environment is set up$/) do
  RAILS_ENV = "test"
end

When(/^I choose a monthly contribution of \$(\d+)$/) do |arg1|
  click_on '$2'
end

When(/^I choose a once\-off contribution of \$(\d+)$/) do |arg1|
  click_on '$100'
end

When(/^I visit the pay what you can page$/) do
  visit contributions_path
end

When(/^I fill in and submit the payment page$/) do
  fill_in "one_acc", with: "1234"
  fill_in "two_acc", with: "1234"
  fill_in "three_acc", with: "1234"
  fill_in "four_acc", with: "1234"
  fill_in "fname", with: "Robidiah"
  fill_in "lname", with: "Guthrison"
  fill_in "address", with: "123 Maple St."
  fill_in "city", with: "Wellington"
  choose "card_type_visa"
  fill_in "name", with: "Robidiah Guthrison"
  fill_in "cvv", with: "123"
  fill_in "email", with: "robidiah.guthrison@hotmail.com"
  check "accept_terms"
  click_on "button"
end

Then(/^I be should be redirected to the sign in page$/) do
  page.should have_css '.sessions.new'
end

Then(/^I should see the SwipeHQ payment page for a monthly \$(\d+) payment$/) do |arg1|
  page.should have_content ('$2 Monthly contribution')
end

Then(/^I should see a confirmation page thanking me for my contribution$/) do
  sleep 5
  page.should have_css('.contributions.thanks')
end

Then(/^I should see the SwipeHQ payment page for a once\-off \$(\d+) payment$/) do |arg1|
  page.should have_content ('$100 one-time contribution')
end
