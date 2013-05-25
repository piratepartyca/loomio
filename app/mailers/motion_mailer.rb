class MotionMailer < BaseMailer
  include ApplicationHelper
  default :from => "\"Loomio\" <noreply@loomio.org>", :css => :email

  def new_motion_created(motion, user)
    @user = user
    @motion = motion
    @group = motion.group
    set_email_locale(user.language_preference, motion.author.language_preference)
    mail( to: user.email,
          reply_to: motion.author_email,
          subject: "#{email_subject_prefix(@group.full_name)} New proposal - #{@motion.name}")
  end

  def motion_closed(motion, email)
    @motion = motion
    @group = motion.group
    set_email_locale(User.find_by_email(email).language_preference, motion.author.language_preference)
    mail( to: email,
          reply_to: "noreply@loomio.org",
          subject: "#{email_subject_prefix(@group.full_name)} Proposal closed - #{@motion.name}")
  end

  def motion_blocked(vote)
    @vote = vote
    @user = vote.user
    @motion = vote.motion
    @discussion = @motion.discussion
    @group = @motion.group
    set_email_locale(@motion.author.language_preference, @user.language_preference)
    mail( to: @motion.author_email,
          reply_to: @group.admin_email,
          subject: "#{email_subject_prefix(@group.full_name)} Proposal blocked - #{@motion.name}")
  end
end
