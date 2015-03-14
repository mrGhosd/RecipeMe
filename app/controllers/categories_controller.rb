class CategoriesController < ApplicationController

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

  end

  def update

  end

  def destroy

  end

  private

  def category_params
    params.require(:category).permit(:title, :description, :image_id)
  end
end