class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorize_resource

  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in @user, event: :authentication
      redirect_to root_path
      set_flash_message(:notice, :success, kind: 'facebook') if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to "/#recipes"
    end
  end

  def twitter
    binding.pry
    request.env['omniauth.auth'].info.email = params[:email]
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in @user, event: :authentication
      redirect_to root_path
      set_flash_message(:notice, :success, kind: 'twitter') if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def vkontakte
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in @user, event: :authentication
      redirect_to root_path
      set_flash_message(:notice, :success, kind: 'vkontakte') if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def instagram
    request.env['omniauth.auth'].info.email = request.env["omniauth.params"]["email"]

    @user = User.from_omniauth(request.env['omniauth.auth'], instagram: true)
    if @user.persisted?
      sign_in @user, event: :authentication
      redirect_to root_path
      set_flash_message(:notice, :success, kind: 'instagram') if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => "http://localhost:3000/users/auth/instagram/callback")
  end
end