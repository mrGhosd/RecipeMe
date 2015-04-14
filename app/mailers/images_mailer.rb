class ImagesMailer < ActionMailer::Base
  default from: "recipeme@info.com"

  def success_removing(user)
    @user = user
    mail to: @user.email
  end
end
