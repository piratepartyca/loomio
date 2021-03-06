class CampaignMailer < ActionMailer::Base
  default from: "\"Pirate Voting - Loomio\" <info@pirateparty.ca>"

  def send_request(campaign, name, email, is_spam)
    @name = name
    @email = email
    @campaign = campaign
    subject = is_spam ? "[Possible spam] " : ""
    subject += "\"#{campaign.name.titlecase}\" Request: #{@name} - #{@email}"
    mail(
      to: campaign.manager_email,
      subject: subject)
  end
end
