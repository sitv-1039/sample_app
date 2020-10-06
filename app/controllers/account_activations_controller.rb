class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute :activated, true
      user.update_attribute :activated_at, Time.zone.now
      # user.activate
      log_in user
      flash[:success] = t "controllers.account_activations.active_success"
      redirect_to user
    else
      flash[:danger] = t "controllers.account_activations.active_fail"
      redirect_to root_url
    end
  end
end
