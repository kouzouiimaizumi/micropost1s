class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    micropost = Micropost.find(params[:micropost_id])
    # 指摘点1
    current_user.favorite(micropost)
    flash[:success] = 'お気に入りにしました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'お気に入り解除しました。'
    redirect_back(fallback_location: root_path)
  end
end