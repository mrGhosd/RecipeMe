class UsersController <ApplicationController
  def show
    user = User.find(params[:id])
    render json: user.to_json(methods: [:recipes, :comments]).html_safe
  end
end