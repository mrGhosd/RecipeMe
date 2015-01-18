class UsersController <ApplicationController
  def show
    user = User.find(params[:id])
    render json: user.to_json(methods: [:recipes, :comments]).html_safe
  end

  def update
    binding.pry
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
    :nickname, :surname, :name, :city, :avatar, :date_of_birth)
  end
end