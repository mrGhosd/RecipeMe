class UserUpdate < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  belongs_to :user
  after_create :send_feed_create_message
  default_scope -> { order('created_at ASC') }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  private

  def send_feed_create_message
    msg = { resource: 'Feed',
            action: 'feed',
            id: self.user.id,
            obj: self
    }
    $redis.publish 'rt-change', msg.to_json
  end
end