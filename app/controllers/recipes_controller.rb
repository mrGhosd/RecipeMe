class RecipesController <ApplicationController
  protect_from_forgery except: :create
  def index
    recipes = Recipe.all
    render json: recipes.to_json(methods: [:images])
  end

  def create
    binding.pry
    Recipe.create(recipes_params)
    head :ok
  end

  private
  def recipes_params
    params.permit(:title, :image)
  end
end