class RecipesController <ApplicationController
  def index
    recipes = Recipe.all
    render json: recipes
  end

  def create
    Recipe.create(recipes_params)
    head :ok
  end

  private
  def recipes_params
    params.require(:recipe).permit(:title)
  end
end