class RecipesController <ApplicationController
  # protect_from_forgery except: :create
  # respond_to :json
  after_action :create_steps, only: :create
  after_action :create_image, only: :create

  def index
    recipes = Recipe.all
    render json: recipes.as_json(only: [:title, :id, :user_id], methods: [:image])
  end

  def create
    binding.pry
    @recipe = Recipe.new(recipes_params)
    if @recipe.save
      render json: { success: true}, status: :ok
    else
      render json: @recipe.errors.to_json, status: :forbidden
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
    params.permit(:title, :user_id, :description, :steps)
  end

  def create_steps
      params[:steps].each do |k, v|
        @recipe.steps.create(v)
      end
  end

  def create_image
    Image.find(params[:image_id]).update(imageable_id: @recipe.id) if params[:image_id].present?
  end
end