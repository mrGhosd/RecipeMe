class CommentsController <ApplicationController
  before_action :load_comment, only: [:update, :show, :destroy, :rating, :liked_users]
  before_action :changed_object, only: [:rating, :liked_users]
  after_action :mail_send, only: :create

  include ChangeObject
  include Rate
  include UsersLiked

  respond_to :json

  def index
    recipe = Recipe.find(params[:recipe_id])
    render json: recipe.comments.order(created_at: :desc).paginate(page: params[:page] || 1, per_page: 5).as_json
  end

  def create
    @comment = Comment.new(comments_params)
    if @comment.save
      render json: @comment.as_json, status: :ok
    else
      render json: @comment.errors.to_json, status: :forbidden
    end
  end

  def show
    render json: @comment.to_json
  end

  def update
    if @comment.update(comments_params)
      render json: @comment.as_json, status: :ok
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