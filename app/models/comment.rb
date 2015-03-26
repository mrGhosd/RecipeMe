class Comment <ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user

  validates :text, presence: true

  include Rate

  def self.send_recipe_author_message(comment)
    CommentsMailer.create_message(comment, comment.recipe, comment.recipe.user).deliver
  end
end