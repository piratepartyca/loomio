require "spec_helper"

describe UserMailer do
  shared_examples_for 'email_meta' do
    it 'renders the receiver email' do
      @mail.to.should == [@user.email]
    end

    it 'renders the sender email' do
      @mail.from.should == ['noreply@loomio.org']
    end
  end

  context 'sending email on membership approval' do
    before :all do
      @user = create(:user)
      @group = create(:group)
      @admin = User.find_by_email(@group.admin_email)
      @admin.language_preference = "es"
      @admin.save
      @mail = UserMailer.group_membership_approved(@user, @group)
    end

    it_behaves_like 'email_meta'

    it 'assigns correct reply_to' do
      @mail.reply_to.should == [@group.admin_email]
    end

    it 'renders the subject' do
      @mail.subject.should == "[Loomio: #{@group.full_name}] Membership approved"
    end

    it 'assigns confirmation_url for email body' do
      @mail.body.encoded.should match("http://localhost:3000/groups/#{@group.id}")
    end

    it "delivers mail in the prefered langauge of the admin, if the user's preference is unknown" do
      pending "Awaiting translation. Replace Grupo with some text from es.yml:email.group_membership_approved"
      @mail.body.encoded.should match('Grupo')
    end
  end

  context 'sends mention email' do
    it 'sends the mail in the prefered language of the user' do
      @user = create(:user, language_preference: "es")
      @comment = create(:comment)
      @mail = UserMailer.mentioned(@user, @comment)
      pending "Awaiting translation. Replace Grupo with some text from es.yml:email.mentioned"
      @mail.body.encoded.should match('Grupo')
    end

    it 'sends the mail in the prefered language of the comment author' do
      @user = create(:user)
      @comment = create(:comment)
      @comment.author.language_preference = "es"
      @comment.author.save
      @mail = UserMailer.mentioned(@user, @comment)
      pending "Awaiting translation. Replace Grupo with some text from es.yml:email.mentioned"
      @mail.body.encoded.should match('Grupo')
    end
  end

  context 'send daily activity email' do
    before :all do
      @user = create(:user, language_preference: "es")
      @group = create(:group)
      @discussion = create(:discussion, group: @group)
      since_time = 24.hours.ago
      results = CollectsRecentActivityByGroup.new(@user, since: since_time).results
      @mail = UserMailer.daily_activity(@user, results, since_time)
    end

    it 'renders the subject' do
      @mail.subject.should == "Loomio - Summary of the last 24 hours"
    end

    it 'delivers mail in the prefered langauge of each user' do
      pending "Awaiting translation. Replace Grupo with some text from es.yml:email.daily_activity"
      @mail.body.encoded.should match('Grupo')
    end
  end

  context 'added_to_group' do
    before :all do
      @user = create(:user)
      @group = create(:group)
      @inviter = stub_model(User, :name => "Mr. Inviter")
      @membership = stub_model(Membership, :user => @user, :group => @group, :inviter => @inviter)
      @mail = UserMailer.added_to_group(@membership)
    end

    it_behaves_like 'email_meta'

    it 'renders the subject' do
      @mail.subject.should match(/been added to a group/)
    end

    it 'assigns correct reply_to' do
      pending "This spec is failing on travis for some reason..."
      @mail.reply_to.should == [@group.admin_email]
    end

    it 'assigns confirmation_url for email body' do
      @mail.body.encoded.should match("http://localhost:3000/groups/#{@group.id}")
    end
  end

  context 'sending email when user is invited to loomio' do
    before :all do
      @inviter = build(:user)
      @group = create(:group)
      @user = User.invite_and_notify!({email: "test@example.com"}, @inviter, @group)
      @mail = UserMailer.invited_to_loomio(@user, @inviter, @group)
    end

    it_behaves_like 'email_meta'

    it 'renders the subject' do
      @mail.subject.should match(
        /#{@inviter.name} has invited you to #{@group.full_name} on Loomio/)
    end

    it 'assigns correct reply_to' do
      @mail.reply_to.should == [@inviter.email]
    end

    it 'assigns inviters name which appears in the email body' do
      @mail.body.encoded.should match(@inviter.name)
    end

    it 'assigns invite_url for email body' do
      @mail.body.encoded.should match(@user.invitation_token)
    end
  end
end
