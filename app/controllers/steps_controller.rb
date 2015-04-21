class StepsController < ApplicationController
  before_action :load_recipe
  after_action :create_image, only: [:create, :update]
  after_action :send_create_step_message, only: :create
  after_action :send_destroy_step_message, only: :destroy
  after_action :send_update_step_message, only: :update



  include Images

  def index
    render json: @recipe.steps.as_json(methods: :image)
  end

  def create
    @step = @recipe.steps.new(steps_params)
    if @step.save
      render json: @step.as_json, status: :ok
    else
      render json: @step.errors.as_json, status: :unforbidden_entity
    end
  end

  def update
    @step = @recipe.steps.find(params[:id])
    if @step.update(steps_params)
      render json: @step.as_json
    else
      render json: @step.errors.as_json
    end
  end

  def show
    render json: @recipe.steps.as_json(methods: :image)
  end

  def destroy
    @step = @recipe.steps.find(params[:id])
    @step.destroy
    head :ok
  end

  private

  def load_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def steps_params
    params.permit(:description, :recipe_id)
  end

  def send_create_step_message
    msg = { resource: 'Step',
            action: 'create',
            id: @recipe.id,
            obj: @step
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_update_step_message
    msg = { resource: 'Step',
            action: 'update',
            id: @recipe.id,
            obj: @step
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_destroy_step_message
    msg = { resource: 'Step',
            action: 'destroy',
            id: @recipe.id,
            obj: @step
    }
    $redis.publish 'rt-change', msg.to_json
    end

  # def create_image
  #   if params[:image].present? && params[:image][:image_id].present?
  #     Image.find(params[:image][:image_id]).update(imageable_id: @step.id)
  #     @step.update_image
  #   end
  # end
end