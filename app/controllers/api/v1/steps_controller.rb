module Api
  module V1
    class StepsController <Api::ApiController
      before_action :load_recipe
      after_action :create_image, only: [:create]
      include Images

      def create
        @step = @recipe.steps.new(steps_params)
        if @step.save
          render json: @step.as_json, status: :ok
        else
          render json: @step.errors.as_json, status: :unprocessable_entity
        end
      end

      private

      def load_recipe
        @recipe = Recipe.find(params[:recipe_id])
      end

      def steps_params
        params.permit(:description, :recipe_id)
      end
    end
  end
end