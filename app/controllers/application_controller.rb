class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session, if: lambda{ |controller| controller.controller_name != "images" }
  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      status = :forbidden
    else
      status = :unauthorized
    end
    render nothing: true, status: status
  end
  authorize_resource if: lambda{ |controller| controller.controller_name != "application" }

  def search
    if params[:filter].present?
      search_params ={ conditions: { tag: params[:data] } }
    else
      search_params = params[:data]
    end
    result = Recipe.search(search_params, star: true)
    render json: result.as_json(only: [:title, :id, :user_id, :rate], methods: [:image])
  end



  def set_locale
    I18n.locale = cookies[:locale] || session[:locale] || I18n.default_locale
  end

end
