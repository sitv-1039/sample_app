class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to user_path(id: user.id)
    else
      flash.now[:danger] = t "views.login.email_pass_invalid"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t "views.logout.success"
    redirect_to root_path
  end
end
