class CommentsMailer < ActionMailer::Base
  default from: "recipeme@info.com"

  def create_message(comment, recipe, user)
    @comment = comment
    @comment_author = comment.user
    @recipe = recipe
    @recipe_author = user
    mail to: @recipe_author.email
  end
end
