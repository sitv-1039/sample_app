class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "controllers.sessions.please_check_mail"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "views.login.email_pass_invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t "views.logout.success"
    redirect_to root_path
  end
end
