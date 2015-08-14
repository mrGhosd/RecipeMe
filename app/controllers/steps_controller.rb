class StepsController < ApplicationController
  before_action :load_recipe

  def destroy
    @step = @recipe.steps.find(params[:id])
    @step.destroy
    head :ok
  end

  private

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end