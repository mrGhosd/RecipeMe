class RecipesController <ApplicationController
  # protect_from_forgery except: :create
  respond_to :json

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
    binding.pry
   recipe =  Recipe.find(params[:id])
    if recipe.update(recipes_params)
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  def show
    recipe = Recipe.find(params[:id])
    render json: recipe.to_json(methods: [:comments, :images])
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
    params.require(:recipe).permit(:title, :description,:user_id, :image)
  end
end