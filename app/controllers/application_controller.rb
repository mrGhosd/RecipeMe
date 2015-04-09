class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session, if: lambda{ |controller| controller.controller_name != "images" }
  before_action :set_locale

  def set_locale
    I18n.locale = cookies[:locale] || session[:locale] || I18n.default_locale
  end
end
