class NewsController < ApplicationController
  before_filter :load_news, except: [:index, :create]
  before_action :changed_object, only: [:rating, :liked_users]
  after_action :create_image, only: [:create, :update]
  after_action :send_create_news_message, only: :create
  after_action :send_image_message, only: :create_image
  after_action :send_destroy_news_message, only: :destroy
  after_action :send_update_news_message, only: :update
  after_action :send_rate_message, only: [:rating]

  include ChangeObject
  include Rate
  include UsersLiked
  include Images

  def index
    @news = News.paginate(page: params[:page] || 1, per_page: 5)
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

  def send_create_news_message
    msg = { resource: 'News',
            action: 'create',
            id: @news.id,
            obj: @news
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_destroy_news_message
    msg = { resource: 'News',
            action: 'destroy',
            id: @news.id,
            obj: @news
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def send_update_news_message
    msg = { resource: 'News',
            action: 'update',
            id: @news.id,
            obj: @news
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def load_news
    @news = News.find(params[:id] || params[:news_id])
  end

  def news_params
    params.require(:news).permit(:title, :text)
  end
end