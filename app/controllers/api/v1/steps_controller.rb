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

      def update
        @step = @recipe.steps.find(params[:id])
        if @step.update(steps_params)
          render json: @step.as_json
        else
          render json: @step.errors.as_json
        end
      end

      def destroy
        @step = @recipe.steps.find(params[:id])
        @step.destroy
        head :ok
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