require 'spec_helper'

describe "GroupSetup" do
  let(:author) { create :user }
  let(:group) { create :group }
  let(:group_setup){ create :group_setup, group: group }

  describe "compose_group!(author)" do
    before do
      group_setup.compose_group!
    end

    it 'copies attributes from group_setup to group' do
      group.name.should == group_setup.group_name
      group.description.should == group_setup.group_description
      group.viewable_by.should == group_setup.viewable_by
      group.members_invitable_by.should == group_setup.members_invitable_by
    end
  end

  describe "create_example_discussion!" do
    before do
      group_setup.create_example_discussion!
    end

    it "creates a loomio helperbot" do
      User.find_by_email('contact@loomio.org').should_not be_nil
    end
    it "creates a example discussion" do
      group.discussions.count.should == 1
    end
    it "creates a example decision for the discussion with the helperbot as the author" do
      group.motions.count.should == 1
    end
  end

  describe "finish!(author)" do
    it "returns true if group, example discussion and proposal are created" do
      group_setup.finish!(author).should be_true
    end

    it "returns false if group, example discussion and proposal are not created" do
      group_setup.stub(:compose_group!).and_return(false)
      group_setup.stub(:create_example_discussion!).and_return(true)
      group_setup.finish!(author).should be_false
    end
  end

  describe "find_or_create_loomio_helper_bot" do
    it "returns the helperbot if it exists" do
      helper_bot = create(:user)
      helper_bot.name = 'Loomio Helper Bot'
      helper_bot.email = 'contact@loomio.org'
      helper_bot.save!

      group_setup.find_or_create_loomio_helper_bot.should == helper_bot
    end

    it "creates a helperbot and returns it if it does not exist" do
      group_setup.find_or_create_loomio_helper_bot.email.should == 'contact@loomio.org'
    end
  end
end