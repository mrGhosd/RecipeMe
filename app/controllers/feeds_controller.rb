class FeedsController < ApplicationController

  def index
    feeds = current_user.feed.page(params[:page] || 1).per(10).to_a
    render json: feeds.as_json, status: :ok
  end

  def show
    render json: current_user.feed.find(params[:id]).as_json, status: :ok
  end
end