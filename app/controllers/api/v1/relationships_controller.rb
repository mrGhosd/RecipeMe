module Api
  module V1
    class RelationshipsController < Api::ApiController
      before_action :doorkeeper_authorize!
      after_action :send_new_follower_mail, only: :create unless Rails.env == "development"
      after_action :send_follower_has_been_removed, only: :destroy unless Rails.env == "development"

      include RelationshipsConcerns

      def create
        @user = User.find(params[:id])
        current_resource_owner.follow!(@user)
        respond_to do |format|
          format.json { render json: @user.as_json, status: :ok }
        end
      end

      def destroy
        @user = User.find(params[:id])
        current_resource_owner.unfollow!(@user)
        respond_to do |format|
          format.json { render json: @user.as_json, status: :ok }
        end
      end

      private

      def send_new_follower_mail
        User.send_follow_message(@user, current_resource_owner)
      end

      def send_follower_has_been_removed
        User.send_unfollow_message(@user, current_resource_owner)
      end
    end
  end
end