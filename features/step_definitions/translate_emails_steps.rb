Given(/^"(.*?)" is a user with an English language preference$/) do |arg1|
  user = FactoryGirl.create :user, name: arg1,
                            email: "#{arg1}@example.org",
                            language_preference: "en"
end

Given(/^"(.*?)" is a user with a Spanish language preference$/) do |arg1|
  user = FactoryGirl.create :user, name: arg1,
                            email: "#{arg1}@example.org",
                            language_preference: "es"
end

Given(/^"(.*?)" is a user without a specified language preference$/) do |arg1|
  user = FactoryGirl.create :user, name: arg1,
                          email: "#{arg1}@example.org"
end

Given(/^"(.*?)" has created a new discussion$/) do |arg1|
  author = User.find_by_email("#{arg1}@example.org")
  group = FactoryGirl.create :group
  @discussion = FactoryGirl.create :discussion, :group => group, author: author
end

Then(/^the new discussion email should be delivered to "(.*?)" in Spanish$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  email = DiscussionMailer.new_discussion_created(@discussion, user)
  email.body.encoded.should include(I18n.t(:group, locale: "es"))
end

Then(/^the new discussion email should be delivered to "(.*?)" in English$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  email = DiscussionMailer.new_discussion_created(@discussion, user)
  email.body.encoded.should include(I18n.t(:group, locale: "en"))
end

Given(/^"(.*?)" has created a new proposal$/) do |arg1|
  author = User.find_by_email("#{arg1}@example.org")
  group = FactoryGirl.create :group
  @discussion = FactoryGirl.create :discussion, group: group
  @motion = FactoryGirl.create :motion, discussion: @discussion, author: author
end

Then(/^the new proposal email should be delivered to "(.*?)" in Spanish$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  email = MotionMailer.new_motion_created(@motion, user)
  email.body.encoded.should include(I18n.t(:group, locale: "es"))
end

Then(/^the new proposal email should be delivered to "(.*?)" in English$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  email = MotionMailer.new_motion_created(@motion, user)
  email.body.encoded.should include(I18n.t(:group, locale: "en"))
end

Given(/^"(.*?)" has blocked a proposal started by "(.*?)"$/) do |arg1, arg2|
  author = User.find_by_email("#{arg2}@example.org")
  group = FactoryGirl.create :group
  @discussion = FactoryGirl.create :discussion, group: group
  motion = FactoryGirl.create :motion, discussion: @discussion, author: author
  user = User.find_by_email("#{arg1}@example.org")
  @vote = FactoryGirl.create :vote, position: "block",
                                    user_id: user.id,
                                    motion_id: motion.id
end

Then(/^the proposal blocked email should be delivered to "(.*?)" in Spanish$/) do |arg1|
  email = MotionMailer.motion_blocked(@vote)
  email.body.encoded.should include(I18n.t(:group, locale: "es"))
end

Given(/^"(.*?)" has closed their proposal$/) do |arg1|
  author = User.find_by_email("#{arg1}@example.org")
  group = FactoryGirl.create :group
  @discussion = FactoryGirl.create :discussion, group: group
  @motion = FactoryGirl.create :motion, discussion: @discussion, author: author
end

Then(/^the proposal closed email should be delivered to "(.*?)" in Spanish$/) do |arg1|
  email = MotionMailer.motion_closed(@motion, "#{arg1}@example.org")
  email.body.encoded.should include(I18n.t("email.proposal_closed.specify_outcome", locale: "es"))
end

Then(/^the proposal closed email should be delivered to "(.*?)" in English$/) do |arg1|
  email = MotionMailer.motion_closed(@motion, "#{arg1}@example.org")
  email.body.encoded.should include(I18n.t("email.proposal_closed.specify_outcome", locale: "en"))
end

When(/^"(.*?)" requests membership to the group$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  group = FactoryGirl.create :group
  @membership = group.add_request!(user)
end

Then(/^the membership request email should be delivered to "(.*?)" in Spanish$/) do |arg1|
  email = GroupMailer.new_membership_request(@membership)
  email.body.encoded.should include(I18n.t("email.membership_request.view_group", locale: "es"))
end

Then(/^the membership request email should be delivered to "(.*?)" in English$/) do |arg1|
  email = GroupMailer.new_membership_request(@membership)
  email.body.encoded.should include(I18n.t("email.membership_request.view_group", locale: "en"))
end

When(/^the daily activity email is sent$/) do
  user = FactoryGirl.create :user
  group = FactoryGirl.create :group
  discussion = FactoryGirl.create :discussion, group: group
  @since_time = 24.hours.ago
  @results = CollectsRecentActivityByGroup.new(user, since: @since_time).results
end

Then(/^"(.*?)" should receive the daily activity email in Spanish$/) do |arg1|
  user = User.find_by_email("#{arg1}@example.org")
  email = UserMailer.daily_activity(user, @results, @since_time)
  email.body.encoded.should include(I18n.t("email.daily_activity.heading", locale: "es"))
end

