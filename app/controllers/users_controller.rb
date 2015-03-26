class UsersController < ApplicationController

  def index

  end

  def show
    user = User.find(params[:id])
    render json: user.as_json(methods: [:followers, :following, :correct_naming, :last_sign_in_at_h])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user.to_json, status: :ok
    else
      render json: user.errors.to_json, status: :forbidden
    end
  end

  private
  def user_params
    params.permit(:email, :password,
                  :nickname, :surname,
                  :name, :date_of_birth, :city)
  end
end