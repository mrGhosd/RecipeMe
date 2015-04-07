class UserUpdatesController < ApplicationController

  def index
    feeds = current_user.feeds
    render json: feeds.as_json, status: :ok
  end

end