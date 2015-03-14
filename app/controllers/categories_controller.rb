class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories.as_json(only: [:title, :created_at])
  end

  def create

  end

  def show

  end

  def update

  end

  def destroy

  end

  private

  def category_params

  end
end