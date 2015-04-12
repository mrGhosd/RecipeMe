class FeedsController < ApplicationController

  def index
    feeds = current_user.feed.paginate(page: params[:page] || 1, per_page: 5).order(created_at: :asc)
    render json: feeds.as_json, status: :ok
  end

  def show
    render json: current_user.feed.find(params[:id]).as_json, status: :ok
  end
end