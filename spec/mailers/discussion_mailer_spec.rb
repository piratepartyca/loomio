require "spec_helper"

describe DiscussionMailer do
  let(:discussion) { create(:discussion) }
  let(:english_user) { create(:user, language_preference: "en")}
  let(:spanish_user) { create(:user, language_preference: "es")}
  let(:group) { discussion.group }

  context 'sending individual email upon new discussion creation' do
    before(:all) do
      group.add_member!(english_user)
      group.add_member!(spanish_user)
      @email1 = DiscussionMailer.new_discussion_created(discussion, english_user)
      @email2 = DiscussionMailer.new_discussion_created(discussion, spanish_user)
    end

    it 'renders the subject' do
      @email1.subject.should == "[Loomio: #{group.full_name}] New discussion - #{discussion.title}"
    end

    it 'renders the sender email' do
      @email1.from.should == ['noreply@loomio.org']
    end

    it 'sends email to group members' do
      @email1.to.should == [english_user.email]
      @email2.to.should == [spanish_user.email]
    end

    it 'assigns url_for discussion' do
      @email1.body.encoded.should match(discussion_url(discussion))
    end

    it 'delivers mail in the prefered langauge of each user' do
      @email1.body.encoded.should match('Group')
      @email2.body.encoded.should match('Grupo')
    end

    it 'assigns reply to' do
      @email1.reply_to.should == [discussion.author_email]
    end
  end
end
