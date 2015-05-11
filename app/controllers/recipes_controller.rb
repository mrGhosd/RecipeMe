class RecipesController < ApplicationController

  after_action :create_image, only: [:create, :update]
  # after_action :send_image_message, only: :create_image
  before_action :changed_object, only: [:rating, :liked_users, :create_image]
  before_action :load_recipe, only: [:update, :show, :destroy, :rating, :liked_users]

  include ChangeObject
  include Images
  include Rate
  include UsersLiked
  include RecipesControllerConcern

  def index
    recipes = Recipe.filter(params).paginate(page: params[:page] || 1, per_page: 12)
    json_params = {only: [:title, :id, :user_id, :rate, :comments_count], methods: [:image]}
    render json: recipes.as_json(json_params)
  end

  def create
    @recipe = Recipe.new(recipes_params)
    if @recipe.save
      render json: @recipe.as_json, status: :ok
    else
      render json: @recipe.errors.to_json, status: :forbidden
    end
  end

  def update
    if @recipe.update(recipes_params)
      render json: { success: true}, status: :ok
    else
      render json: @recipe.errors.to_json, status: :forbidden
    end
  end


  def show
    respond_to do |format|
      format.json { render json: @recipe.as_json(except: [:comments_count, :recipe_ingridients_count, :steps_count],
                                                 methods: [:comments_list, :image, :steps_list, :tag_list, :ingridients_list, :user, :created_at_h]) }
    end
  end

  def destroy
    if @recipe.destroy
      render json: { success: true}, status: :ok
    else
      render json: { success: false}, status: :forbidden
    end
  end



  private

  def recipes_params
    params.permit(:title, :user_id, :description,  :tag_list, :category_id, :steps => [])
  end

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id] || params[:id])
  end

  def create_steps
      params[:steps].each_with_index do |k, v|
        step = @recipe.steps.create(description: k[:description])
        Image.find(k[:image]).update(imageable_id: step.id) if k[:image].present?
      end
  end
end