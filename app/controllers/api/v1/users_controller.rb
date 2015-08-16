module Api
  module V1
    class UsersController < Api::ApiController
      prepend_before_filter :allow_params_authentication!, :only => :create
      skip_before_filter :restrict_access_by_token, :only => :create
      before_action :doorkeeper_authorize!, only: [:profile, :info]

      def create
        user = User.new(user_params)
        if user.save
          render json:user.as_json, status: :ok
        else
          render json: user.errors.to_json, status: :unprocessable_entity
        end
      end

      def show
        user = User.find(params[:id])
        render json: user.as_json(methods: [:followers_ids, :following_ids, :recipes_count, :comments_count])
      end

      def profile
        render json: current_resource_owner.as_json(except: [:password, :password_encrypted], methods: [:followers_ids, :following_ids, :recipes_count, :comments_count])
      end

      def info
        user = User.find(params[:user_id])
        objects = user.send(params[:entity]).paginate(page: params[:page] || 1, per_page: 12)
        render json: objects.as_json(methods: [:user, :image, :votes, :recipe, :followers_ids, :following_ids, :recipes_count, :comments_count])
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end