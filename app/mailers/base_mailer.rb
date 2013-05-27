class BaseMailer < ActionMailer::Base
  def set_email_locale(preference, fallback)
    if preference.present?
      I18n.locale = preference
    elsif fallback.present?
      I18n.locale = fallback
    elsif preference.blank? && fallback.blank?
      I18n.locale = I18n.default_locale
    end
  end
end
