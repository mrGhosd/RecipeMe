class UsersController < ApplicationController
  before_action :load_user, only: [:following, :followers, :comments, :recipes]
  after_action :send_update_user_data, only: :update

  def show
    user = User.find(params[:id])
    render json: user.as_json(methods: [:followers_list, :following_list, :correct_naming, :last_sign_in_at_h])
  end

  def following
    render json: @user.following.as_json(methods: [:last_sign_in_at_h, :correct_naming])
  end

  def followers
    render json: @user.followers.as_json(methods: [:last_sign_in_at_h, :correct_naming])
  end

  def feed
    feed = current_user.feed
    render json: feed.as_json, status: :ok
  end

  def recipes
    render json: @user.recipes.as_json(methods: :image), status: :ok
  end

  def comments
    render json: @user.comments.as_json(methods: :recipe), status: :ok
  end

  def locale
    locale = params[:locale].downcase.eql?("en") ? "ru" : "en"
    session[:locale] = locale
    head :ok
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user.as_json(methods: [:followers_list, :following_list, :correct_naming, :last_sign_in_at_h]), status: :ok
    else
      render json: @user.errors.to_json, status: :forbidden
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end

  def send_update_user_data
    msg = { resource: 'User',
            action: 'update',
            id: @user.id,
            obj: @user
    }

    $redis.publish 'rt-change', msg.to_json
  end

  def user_params
    params.permit(:email, :password,
                  :nickname, :surname,
                  :name, :date_of_birth, :city, :avatar)
  end
end