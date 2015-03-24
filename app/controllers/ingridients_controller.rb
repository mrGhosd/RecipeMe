class IngridientsController < ApplicationController
  # after_action :update_recipe_connection, only: :create
  # before_action :test_action, only: :create
  def index
    @ingridients = Ingridient.all
    render json: @ingridients.as_json
  end

  def test_action

    ingridient = Ingridient.find_by name: params[:name]
    if ingridient.present?
      if update_recipe_connection(ingridient)
        render json:ingridient.as_json, status: :ok
      else
        render json:ingridient.errors.as_json, status: :unprocessible_entity
      end
    end
  end

  def create
    @ingridient = Ingridient.new(ingridient_params)
    if @ingridient.save
      update_recipe_connection(@ingridient)
      render json:@ingridient.as_json, status: :ok
    else
      render json:@ingridient.errors.as_json, status: :unprocessible_entity
    end
  end

  def show

  end

  def update

  end

  def destroy

  end

  private

  def create_ingridient

  end


  def ingridient_params
    params.permit(:name)
  end

  def update_recipe_connection(ingridient)
    ingridient.recipe_ingridients.create(recipe_id: params[:recipe_id], size: params[:size])
  end

end