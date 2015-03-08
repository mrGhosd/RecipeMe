class RecipesController <ApplicationController
  # protect_from_forgery except: :create
  # respond_to :json

  def index
    recipes = Recipe.all
    render json: recipes.to_json(methods: [:comments, :images])
  end

  def create
    binding.pry
    recipe = Recipe.new(recipes_params)
    if recipe.save
      render json: { success: true}, status: :ok
    else
      render json: recipe.errors.to_json, status: :forbidden
    end
  end

  def update
   recipe =  Recipe.find(params[:id])
    if recipe.update(recipes_params)
      render json: { success: true}, status: :ok
    else
      render json: recipe.errors.to_json, status: :forbidden
    end
  end

  def show
    recipe = Recipe.find(params[:id])
    respond_to do |format|
      format.json { render json: recipe.to_json(methods: [:comments, :images, :steps]) }
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    if recipe.destroy
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  private
  def recipes_params
    params[:steps].transform_keys!{|key| key[1,1]}
    params.permit(:title, :user_id, :description, :image, :steps)
  end
end