class RelationshipsController < ApplicationController
  after_action :send_new_follower_mail, only: :create
  after_action :send_follower_has_been_removed, only: :destroy

  def create
    @user = User.find(params[:id])
    current_user.follow!(@user)
    respond_to do |format|
      format.json { render json: @user.as_json, status: :ok }
    end
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    respond_to do |format|
      format.json { render json: @user.as_json, status: :ok }
    end
  end

  private

  def send_new_follower_mail
   User.send_follow_message(@user, current_user)
  end

  def send_follower_has_been_removed
    User.send_unfollow_message(@user, current_user)
  end

end