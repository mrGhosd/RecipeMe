module Api
  module V1
    class UsersController < Api::ApiController
      prepend_before_filter :allow_params_authentication!, :only => :create
      skip_before_filter :restrict_access_by_token, :only => :create
      before_action :doorkeeper_authorize!, only: [:profile]

      def create
        user = User.new(user_params)
        if user.save
          render json:user.as_json, status: :ok
        else
          render json: user.errors.to_json, status: :unprocessable_entity
        end
      end

      def profile
        render json: current_resource_owner.as_json(except: [:password, :password_encrypted])
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end