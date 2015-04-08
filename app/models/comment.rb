class Comment <ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user

  validates :text, presence: true
  after_create :update_comment

  include Rate

  def self.send_recipe_author_message(comment)
    CommentsMailer.create_message(comment, comment.recipe, comment.recipe.user).deliver
  end

  def update_comment
    CommentUpdate.create(user_id: self.user.id, update_type: 'create',
    update_entity: self.class.to_s, update_entity_for: self.class.to_s, update_id: self.id)
  end
end