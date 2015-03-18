class NewsController < ApplicationController
  before_filter :load_news, except: [:index, :create]
  before_action :change_object, only: [:rating, :liked_users]
  after_action :create_image, only: [:create, :update]
  include ChangeObject
  include Rate
  include UsersLiked

  def index
    @news = News.all
    render json: @news.as_json(methods: :image)
  end

  def create
    @news = News.new(news_params)
    if @news.save
      render json: @news.as_json(methods: :image), status: :ok
    else
      render json: @news.errors.as_json, status: :unprocessibe_entity
    end
  end

  def show
    render json: @news.as_json(methods: :image)
  end

  def update
    if @news.update(news_params)
      render json: @news.as_json(methods: :image), status: :ok
    else
      render json: @news.errors.as_json, status: :unprocessible_entity
    end
  end

  def destroy
    @news.destroy
    head :ok
  end

  private

  def load_news
    @news = News.find(params[:id] || params[:news_id])
  end

  def news_params
    params.require(:news).permit(:title, :text)
  end

  def create_image
    if params[:image].present? && params[:image][:image_id].present?
      Image.find(params[:image][:image_id]).update(imageable_id: @news.id)
      @news.update_image
    end
  end
end