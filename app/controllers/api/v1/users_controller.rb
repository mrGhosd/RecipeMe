module Api
  module V1
    class UsersController < Api::ApiController
      before_action :doorkeeper_authorize!, only: [:profile, :create]

      def create

      end

      def profile
        render json: current_resource_owner.as_json(except: [:password, :password_encrypted], methods: [:recipes, :comments, :followers, :following])
      end
    end
  end
end