class CategoriesController < ApplicationController
  before_action :load_category, except: [:index, :create]
  after_action :create_image, only: [:create, :update]

  include Images

  def index
    categories = Category.paginate(page: params[:page] || 1, per_page: 10)
    render json: categories.as_json(only: [:id, :title, :created_at, :slug])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category.as_json, status: :ok
    else
      render json: @category.errors.as_json, status: :unprocessable_entity
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
    render json: @category.recipes.order(created_at: :desc).paginate(page: params[:page] || 1, per_page: 8).as_json(only: [:title, :id, :user_id, :slug], methods: [:image])
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :description, :image_id)
  end
end