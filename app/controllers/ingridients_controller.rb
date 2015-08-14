class IngridientsController < ApplicationController
  before_action :load_recipe, only: [:destroy]
  before_action :load_ingridient, only: [:destroy]


  def destroy
    Recipe.find(params[:recipe_id]).ingridients.find(params[:id]).destroy
    @ingridient.recipe_ingridients.find_by(recipe_id: params[:recipe_id], ingridient_id: params[:id]).try(:destroy)
    head :ok
  end

  private

  def load_ingridient
    @ingridient = Ingridient.find(params[:id])
  end

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end