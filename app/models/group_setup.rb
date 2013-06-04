class GroupSetup < ActiveRecord::Base
  attr_accessible :group_name, :group_description, :viewable_by, :members_invitable_by,
                  :recipients

  after_initialize :set_default_close_at_date_and_time

  belongs_to :group

  def compose_group!
    self.group.update_attributes(name: group_name,
                                 description: group_description,
                                 viewable_by: viewable_by,
                                 members_invitable_by: members_invitable_by)
    self.group.save!
  end

  def create_example_discussion!
    helper_bot = find_or_create_loomio_helper_bot
    example_discussion = Discussion.new
    example_discussion.title = I18n.t('example_discussion.title')
    example_discussion.description = I18n.t('example_discussion.description')
    example_discussion.group = self.group
    example_discussion.author = helper_bot
    example_discussion.save!
    example_motion = Motion.new
    example_motion.name = I18n.t('example_motion.name')
    example_motion.description = I18n.t('example_motion.description')
    example_motion.author = helper_bot
    example_motion.discussion = example_discussion
    example_motion.close_at_date = 3.days.from_now.to_date
    example_motion.close_at_time = Time.now.strftime("%H:00")
    example_motion.close_at_time_zone = helper_bot.time_zone
    example_motion.save!
  end

  def finish!(author)
    if compose_group!
      create_example_discussion!
      return true
    end
    false
  end

  def find_or_create_loomio_helper_bot
    helper_bot = User.find_by_email('contact@loomio.org')
    unless helper_bot
      helper_bot = User.new
      helper_bot.name = 'Loomio Helper Bot'
      helper_bot.email = 'contact@loomio.org'
      helper_bot.password = 'password'
      helper_bot.save!
    end
    helper_bot
  end

  private
    def set_default_close_at_date_and_time
      self.close_at_date ||= 3.days.from_now.to_date
      self.close_at_time = Time.now.strftime("%H:00")
    end
end
