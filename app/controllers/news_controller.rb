class NewsController < ApplicationController
  before_filter :load_news, except: [:index, :create]

  def index
    @news = News.all
    render json: @news.as_json
  end

  def create
    @news= News.new(news_params)
    if @news.save
      render json: @news.as_json, status: :ok
    else
      render json: @news.errors.as_json, status: :unprocessibe_entity
    end
  end

  def show
    render json: @news.as_json
  end

  def update
    if @news.update(news_params)
      render json: @news.as_json, status: :ok
    else
      render json: @news.errors.as_json, status: :unprocessible_entity
    end
  end

  private

  def load_news
    @news = News.find(params[:id])
  end

  def news_params
    params.require(:news).permit(:title, :text)
  end
end