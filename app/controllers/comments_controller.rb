class CommentsController <ApplicationController
  respond_to :json

  def index
    recipe = Recipe.find(params[:recipe_id])
    render json: recipe.comments.to_json
  end

  def create
    comment = Comment.new(comments_params)
    if comment.save
      render json: comment.to_json, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  def show
    comment = Comment.find(params[:id])
    render json: comment.to_json
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comments_params)
      render json: comment.to_json, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  private

  def comments_params
    params.permit(:recipe_id, :user_id, :text)
  end
end