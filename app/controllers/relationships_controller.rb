class RelationshipsController < ApplicationController
  after_action :send_new_follower_mail, only: :create unless Rails.env == "development"
  after_action :send_following_user_message, only: :create
  after_action :send_follower_has_been_removed, only: :destroy unless Rails.env == "development"
  after_action :send_unfollowing_user_message, only: :destroy

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

  def send_following_user_message
    msg = { resource: 'User',
            action: 'follow',
            id: @user.id,
            obj: @user
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_unfollowing_user_message
    msg = { resource: 'User',
            action: 'unfollow',
            id: @user.id,
            obj: @user
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_follower_has_been_removed
    User.send_unfollow_message(@user, current_user)
  end
end