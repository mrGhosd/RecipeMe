class RecipesController <ApplicationController
  protect_from_forgery except: :create
  def index
    recipes = Recipe.all
    render json: recipes.to_json(methods: [:images])
  end

  def create
    binding.pry
    recipe = Recipe.new(recipes_params)
    if recipe.save
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  def update
   recipe =  Recipe.find(params[:id])
    if recipe.update(recipes_params)
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end

  def show
    recipe = Recipe.find(params[:id])
    render json: recipe.to_json(methods: [:images])
  end

  private
  def recipes_params
    params.permit(:title, :description, :image)
  end
end