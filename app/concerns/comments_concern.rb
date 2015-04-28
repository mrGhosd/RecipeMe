module CommentsConcern
  include WebsocketsMessage
  extend ActiveSupport::Concern

  included do
    after_action :send_create_comment_message, only: :create
    after_action :send_update_comment_message, only: :update
    after_action :send_destroy_comment_message, only: :destroy
  end

  def send_destroy_comment_message
    message({ resource: 'Recipe',
              action: 'comment-destroy',
              id: @comment.recipe.id,
              obj: @comment,
              count: @comment.recipe.comments_count - 1})
  end

  def send_update_comment_message
    message({ resource: 'Recipe',
              action: 'comment-update',
              id: @comment.recipe.id,
              obj: @comment })
  end

  def send_create_comment_message
    message({ resource: 'Recipe',
              action: 'comment-create',
              id: @comment.recipe.id,
              obj: @comment,
              count: @comment.recipe})
  end
end