class CommentsController <ApplicationController
  before_action :load_comment, only: [:update, :show, :destroy, :rating, :liked_users]
  before_action :change_object, only: [:rating, :liked_users]
  after_action :mail_send, only: :create
  after_action :send_create_comment_message, only: :create
  after_action :send_update_comment_message, only: :update
  after_action :send_destroy_comment_message, only: :destroy

  include ChangeObject
  include Rate
  include UsersLiked
  respond_to :json

  def index
    recipe = Recipe.find(params[:recipe_id])
    render json: recipe.comments.order(created_at: :asc).paginate(page: params[:page] || 1, per_page: 5).as_json
  end

  def create
    @comment = Comment.new(comments_params)
    if @comment.save
      render json: @comment.to_json, status: :ok
    else
      render json: @comment.errors.to_json, status: :forbidden
    end
  end

  def show
    render json: @comment.to_json
  end

  def update
    if @comment.update(comments_params)
      render json: @comment.to_json, status: :ok
    else
      render json: @comment.errors.to_json, status: :forbidden
    end
  end

  def destroy
    if @comment.destroy
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  private

  def send_destroy_comment_message
    msg = { resource: 'Recipe',
            action: 'comment-destroy',
            id: @comment.recipe.id,
            obj: @comment,
            count: @comment.recipe.comments_count - 1
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_update_comment_message
    msg = { resource: 'Recipe',
            action: 'comment-update',
            id: @comment.recipe.id,
            obj: @comment
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_create_comment_message
    msg = { resource: 'Recipe',
            action: 'comment-create',
            id: @comment.recipe.id,
            obj: @comment,
            count: @comment.recipe
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def mail_send
    Comment.send_recipe_author_message(@comment)
  end

  def comments_params
    params.require(:comment).permit(:recipe_id, :user_id, :text)
  end
end