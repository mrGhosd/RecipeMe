class RecipesMailer < ActionMailer::Base
  default from: "recipeme@info.com"

  def create_message(follower, author, recipe)
    @user = follower
    @author = author
    @recipe = recipe
    mail to: @user.email
  end
end
