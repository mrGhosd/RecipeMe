class CategoriesController < ApplicationController
  before_action :load_category, except: [:index, :create]
  def index
    categories = Category.all
    render json: categories.as_json(only: [:id, :title, :created_at])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category.as_json, status: :ok
    else
      render json: @category.errors.as_json, status: :unforbidden_entity
    end
  end

  def show
    render json: @category.as_json
  end

  def update
    if @category.update(category_params)
      render json: {success: true}.to_json, status: :ok
    else
      render json: @category.errors.to_json, status: :unprocessible_entity
    end
  end

  def destroy
    @category.destroy
    head :ok
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :description, :image_id)
  end
end