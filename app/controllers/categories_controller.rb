class CategoriesController < ApplicationController
  before_action :load_category, except: [:index, :create]
  after_action :create_image, only: [:create, :update]
  after_action :send_create_category_message, only: :create
  after_action :send_destroy_category_message, only: :destroy
  include Images

  def index
    categories = Category.paginate(page: params[:page] || 1, per_page: 10)
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
    render json: @category.recipes.paginate(page: params[:page] || 1, per_page: 8).as_json(only: [:title, :id, :user_id], methods: [:image])
  end

  private

  def send_create_category_message
    msg = { resource: 'Category',
            action: 'create',
            id: @category.id,
            obj: @category,
            image: @category.image
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_destroy_category_message
    msg = { resource: 'Category',
            action: 'destroy',
            id: @category.id,
            obj: @category
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :description, :image_id)
  end
end