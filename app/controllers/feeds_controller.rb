class FeedsController < ApplicationController

  def index
    feeds = current_user.feed.limit(5)
    render json: feeds.as_json, status: :ok
  end

  def show

  end
end