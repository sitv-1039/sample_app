class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale_before_action

  def default_url_options
    {locale: I18n.locale}
  end

  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "models.users.please_login"
    redirect_to login_url
  end

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
