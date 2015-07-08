module Api
  module V1
    class CommentsController < Api::ApiController
      before_action :doorkeeper_authorize!, only: [:create]
      after_action :mail_send, only: :create

      def index
        recipe = Recipe.find(params[:recipe_id])
        render json: recipe.comments.as_json
      end

      def create
        @comment = Comment.new(comments_params)
        if @comment.save
          render json: @comment.as_json, status: :ok
        else
          render json: @comment.errors.to_json, status: :forbidden
        end
      end

      def destroy
        comment = Comment.find(params[:id])
        comment.destroy
        render json: {success: true}.to_json
      end

      private

      def comments_params
        params.require(:comment).permit(:recipe_id, :user_id, :text)
      end

      def mail_send
        Comment.send_recipe_author_message(@comment)
      end
    end
  end
end