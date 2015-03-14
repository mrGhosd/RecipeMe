class CategoriesController < ApplicationController
  before_action :load_category, except: [:index, :create]
  after_action :create_image, only: [:create, :update]
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
    render json: @category.as_json(methods: [:image, :recipes])
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

  def recipes
    binding.pry
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :description, :image_id)
  end

  def create_image
    if params[:image][:image_id].present?
      Image.find(params[:image][:image_id]).update(imageable_id: @category.id)
      @category.update_image
    end
  end
end