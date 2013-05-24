class BaseMailer < ActionMailer::Base
  def set_email_locale(preference, fallback)
    if preference && preference.length > 0
      I18n.locale = preference
    elsif fallback && fallback.length > 0
      I18n.locale = fallback
    elsif preference.blank? && fallback.blank?
      I18n.locale = I18n.default_locale
    end
  end
end
