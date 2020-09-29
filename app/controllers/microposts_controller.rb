class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "controllers.micropost.create_success"
      redirect_to root_url
    else
      @feed_items = current_user.feed.page(params[:page]).per Settings.page
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t "controllers.micropost.delete_success"
    redirect_to request.referer || root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end
end
