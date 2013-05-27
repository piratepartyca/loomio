require "spec_helper"

describe MotionMailer do
  let(:user) { create(:user, language_preference: "en") }
  let(:spanish_user) { create(:user, language_preference: "es")}
  let(:group) { create(:group) }
  let(:discussion) { create(:discussion, group: group) }
  let(:motion) { create(:motion, discussion: discussion) }

  describe 'sending email on new motion creation' do
    before(:all) do
      @email = MotionMailer.new_motion_created(motion, user)
      @email2 = MotionMailer.new_motion_created(motion, spanish_user)
    end

    it 'renders the subject' do
      @email.subject.should == "[Loomio: #{group.full_name}] New proposal - #{motion.name}"
    end

    it 'renders the sender email' do
      @email.from.should == ['noreply@loomio.org']
    end

    it 'assigns reply to' do
      @email.reply_to.should == [motion.author_email]
    end

    it 'sends email to group members but not author' do
      @email.to.should == [user.email]
    end

    it 'delivers mail in the prefered langauge of each user' do
      @email.body.encoded.should match('Group')
      @email2.body.encoded.should match('Grupo')
    end

    it 'assigns group.name' do
      @email.body.encoded.should match(group.full_name)
    end

    it 'assigns url_for motion' do
      @email.body.encoded.should match(discussion_url(discussion))
    end
  end

  describe 'sending email when motion closes' do
    before(:all) do
      @email = MotionMailer.motion_closed(motion, spanish_user.email)
    end

    it 'delivers mail in the prefered langauge of each user' do
      pending "Awaiting translation. Replace Grupo with some text from es.yml:email.proposal_closed.intro"
      @email.body.encoded.should match('Grupo')
    end
  end

  describe 'sending email when motion is blocked' do
    before(:all) do
      @vote = Vote.new(position: "block")
      @vote.motion = motion
      @vote.user = user
      @vote.save
      motion.author.language_preference = "es"
      @email = MotionMailer.motion_blocked(@vote)
    end

    it 'renders the subject' do
      @email.subject.should match(/Proposal blocked - #{motion.name}/)
    end

    it 'renders the sender email' do
      @email.from.should == ['noreply@loomio.org']
    end

    it 'sends to the motion author' do
      @email.to.should == [motion.author_email]
    end

    it 'assigns reply to' do
      pending "This spec is failing on travis for some reason..."
      @email.reply_to.should == [group.admin_email]
    end

    it 'delivers mail in the prefered langauge of the motion author' do
      @email.body.encoded.should match('Grupo')
    end

    it 'assigns group.full_name' do
      @email.body.encoded.should match(group.full_name)
    end

    it 'assigns url_for motion' do
      @email.body.encoded.should match(/\/discussions\/#{motion.discussion.id}/)
    end
  end
end
