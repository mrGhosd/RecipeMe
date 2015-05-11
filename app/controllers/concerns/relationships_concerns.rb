module RelationshipsConcerns
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_follower_user_message, only: :create
    after_action :send_following_user_message, only: :create
    after_action :send_unfollower_user_message, only: :destroy
    after_action :send_unfollowing_user_message, only: :destroy
  end

  def send_follower_user_message
    message({ resource: 'User',
              action: 'follow',
              id: @user.id,
              obj: current_user
            })
  end

  def send_following_user_message
    message({ resource: 'User',
              action: 'following',
              id: current_user.id,
              obj: @user })
  end

  def send_unfollowing_user_message
    message({ resource: 'User',
              action: 'unfollowing',
              id: current_user.id,
              obj: @user })
  end

  def send_unfollower_user_message
    message({ resource: 'User',
              action: 'unfollow',
              id: @user.id,
              obj: current_user })
  end
end