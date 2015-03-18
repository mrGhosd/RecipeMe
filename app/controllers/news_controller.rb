class NewsController < ApplicationController
  def index
    @news = News.all
    render json: @news.as_json
  end
end