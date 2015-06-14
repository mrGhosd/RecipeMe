module CommentsConcern
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_create :send_create_comment_message
    after_update :send_update_comment_message
    after_destroy :send_destroy_comment_message
  end

  def send_destroy_comment_message
    message({ resource: 'Recipe',
              action: 'comment-destroy',
              id: self.recipe.id,
              obj: self.as_json,
              count: self.recipe.comments_count - 1})
  end

  def send_update_comment_message
    message({ resource: 'Recipe',
              action: 'comment-update',
              id: self.recipe.id,
              obj: self.as_json,
              user: self.user})
  end

  def send_create_comment_message
    message({ resource: 'Recipe',
              action: 'comment-create',
              id: self.recipe.id,
              obj: self,
              count: self.recipe,
              user: self.user})
  end
end