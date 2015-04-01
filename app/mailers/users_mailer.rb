class UsersMailer < ActionMailer::Base
  default from: "recipeme@info.com"

  def follow(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email
  end

  def unfollow(user, follower)
    @user = user
    @follower = follower
    mail to: @user.email
  end
end
