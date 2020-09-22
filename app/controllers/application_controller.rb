class ApplicationController < ActionController::Base
  before_action :set_locale_before_action

  private

  def set_locale_before_action
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end
end
