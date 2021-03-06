class UserMailer < ActionMailer::Base
  include ApplicationHelper
  include ERB::Util
  include ActionView::Helpers::TextHelper
  default :from => "\"Pirate Voting - Loomio\" <info@pirateparty.ca>", :css => :email

  def daily_activity(user, activity, since_time)
    @user = user
    @activity = activity
    @since_time = since_time
    @since_time_formatted = since_time.strftime('%A, %-d %B')
    @groups = user.groups.sort{|a,b| a.full_name <=> b.full_name }
    mail to: @user.email,
         subject: "Loomio - Summary of the last 24 hours"
  end

  def mentioned(user, comment)
    @user = user
    @comment = comment
    @rendered_comment_body = render_rich_text(comment.body, comment.uses_markdown)
    @discussion = comment.discussion
    mail to: @user.email,
         subject: "#{comment.author.name} mentioned you in the #{comment.group.name} group on Loomio"
  end

  def group_membership_approved(user, group)
    @user = user
    @group = group
    mail( :to => user.email,
          :reply_to => @group.admin_email,
          :subject => "#{email_subject_prefix(@group.full_name)} Membership approved")
  end

  def motion_closing_soon(user, motion)
    @user = user
    @motion = motion
    mail to: user.email,
         reply_to: @motion.author.email,
         subject: "[Loomio - #{@motion.group.name}] Proposal closing soon: #{@motion.name}"
  end

  # Invited to loomio (assumes user has been invited to a group at the same time)
  def invited_to_loomio(new_user, inviter, group)
    @new_user = new_user
    @inviter = inviter
    @group = group
    mail( :to => new_user.email,
          :reply_to => inviter.email,
          :subject => "#{inviter.name} has invited you to #{group.full_name} on Loomio")
  end
end
