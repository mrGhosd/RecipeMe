class StepsController < ApplicationController
  before_action :load_recipe
  after_action :create_image, only: :create

  def index
    render json: @recipe.steps.as_json(methods: :image)
  end

  def create
    @step = @recipe.steps.create(steps_params)
    if @step.save
      render json: @step.as_json, status: :ok
    else
      render json: @step.errors.as_json, status: :unforbidden_entity
    end

  end

  def update
    @step = @recipe.steps.find(params[:id])
    @step.update(steps_params)
    render json: @step.as_json
  end

  def destroy
    step = @recipe.find(params[:id])
    step.destroy
    head :ok
  end

  private

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def steps_params
    params.permit(:description, :recipe_id)
  end

  def create_image
    Image.find(params[:image][:image_id]).update(imageable_id: @step.id) if params[:image][:image_id].present?
  end
end