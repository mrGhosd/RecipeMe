class IngridientsController < ApplicationController
  before_action :load_recipe, only: [:create, :recipe_ingridients, :destroy]
  before_action :load_ingridient, only: [:update, :destroy]

  def index
    @ingridients = Ingridient.all
    render json: @ingridients.as_json, status: :ok
  end

  def recipe_ingridients
    render json: @recipe.ingridients_list.as_json, status: :ok
  end

  def create
    common_ingridient = Ingridient.find_by name: params[:name]
    @ingridient = @recipe.ingridients.find_by name: params[:name]
    if @ingridient.present? && common_ingridient.present?
      render json: @ingridient.as_json, status: :ok
    elsif @ingridient.blank? && common_ingridient.present?
      add_ingridient_to_recipe(common_ingridient)
      @ingridient = common_ingridient
      render json: @ingridient.as_json, status: :ok
    else
      @ingridient = Ingridient.new(ingridient_params)
      if @ingridient.save
        add_ingridient_to_recipe(@ingridient)
        render json: @ingridient.as_json, status: :ok
      else
        render json: @ingridient.errors.as_json, status: :unprocessible_entity
      end
    end
  end

  def show
    ingridient = Ingridient.find(params[:id])
    render json: ingridient.as_json, status: :ok
  end

  def update
    if @ingridient.save(ingridient_params)
      render json: @ingridient.as_json, status: :ok
    else
      render json: @ingridient.errors.as_json, status: :unprocessible_entity
    end
  end

  def destroy
    Recipe.find(params[:recipe_id]).ingridients.find(params[:id]).destroy
    @ingridient.recipe_ingridients.find_by(recipe_id: params[:recipe_id], ingridient_id: params[:id]).try(:destroy)
    head :ok
  end

  private

  def add_ingridient_to_recipe(ingridient)
    recipe = Recipe.find(params[:recipe_id])
    recipe.recipe_ingridients.create(ingridient: ingridient, size: params[:in_size])
  end

  def load_ingridient
    @ingridient = Ingridient.find(params[:id])
  end

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def ingridient_params
    params.permit(:name)
  end

end