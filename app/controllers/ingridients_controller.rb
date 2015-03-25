class IngridientsController < ApplicationController
  before_action :load_recipe, only: :recipe_ingridients
  before_action :load_ingridient, only: :destroy
  after_action :update_recipe_connection, only: [:create]
  def index
    @ingridients = Ingridient.all
    render json: @ingridients.as_json
  end

  def recipe_ingridients
    render json: @recipe.ingridients_list.as_json, status: :ok
  end

  def create
    @ingridient = Ingridient.find_by name: params[:name]
    if @ingridient.present?
      render json: @ingridient.as_json, status: :ok
    else
      @ingridient = Ingridient.new(ingridient_params)
      if @ingridient.save
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

  end

  def destroy
    @ingridient.destroy
    head :ok
  end

  private

  def load_ingridient
    @ingridient = Ingridient.find(params[:id])
  end

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def ingridient_params
    params.permit(:name)
  end

  def update_recipe_connection
    ingridient_recipe = @ingridient.recipe_ingridients.new(recipe_id: params[:recipe_id], size: params[:size])
    ingridient_recipe.save
  end

end