module Api
  module V1
    class RecipesController < Api::ApiController
      before_action :load_recipe, only: [:update, :show, :destroy, :rating]
      before_action :doorkeeper_authorize!, only: [:create, :update, :destroy]
      after_action :create_image, only: [:create, :update]

      include ChangeObject
      include Images
      include Rate
      include UsersLiked
      include RecipesControllerConcern

      def index
        recipes = Recipe.filter(params).paginate(page: params[:page] || 1, per_page: 12)
        render json: recipes.as_json(methods: [:user, :image, :votes])
      end

      def show
        render json: @recipe.as_json(methods: [:user, :image, :votes, :steps_list,
                                               :ingridients_list, :comments_list, :tag_list, :category])
      end

      def create
        @recipe = Recipe.new(recipes_params)
        if @recipe.save
          render json: @recipe.as_json, status: :ok
        else
          render json: @recipe.errors.to_json, status: :forbidden
        end
      end

      def update
        if @recipe.update(recipes_params)
          render json: @recipe.as_json, status: :ok
        else
          render json: @recipe.errors.to_json, status: :forbidden
        end
      end

      def destroy
        if @recipe.destroy
          render json: { success: true}, status: :ok
        else
          render json: { success: false}, status: :forbidden
        end
      end

      private

      def load_recipe
        @recipe = Recipe.find(params[:id] || params[:recipe_id])
      end

      def recipes_params
        params.require(:recipe).permit(:title, :user_id, :description,  :tag_list, :category_id, :time, :persons, :difficult, :steps => [])
      end
    end

  end
end