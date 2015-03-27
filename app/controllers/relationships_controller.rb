class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:id])
    current_user.follow!(@user)
    respond_to do |format|
      format.json { render json: { success: true }.to_json, status: :ok }
    end
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    respond_to do |format|
      format.json { render json: { success: true }.to_json, status: :ok }
    end
  end
end