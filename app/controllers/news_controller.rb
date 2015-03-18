class NewsController < ApplicationController
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

  private

  def news_params
    params.require(:news).permit(:title, :text)
  end
end