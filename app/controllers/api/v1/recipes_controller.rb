module Api
  module V1
    class RecipesController < Api::ApiController
      before_action :doorkeeper_authorize!, only: [:create]
      after_action :create_image, only: [:create, :update]

      include ChangeObject
      include Images
      include Rate
      include UsersLiked
      include RecipesControllerConcern

      def index
        recipes = Recipe.filter(params).paginate(page: params[:page] || 1, per_page: 12)
        render json: recipes.as_json(methods: [:user, :image])
      end

      def show
        recipes = Recipe.find(params[:id])
        render json: recipes.as_json(methods: [:user, :image, :steps_list, :ingridients_list, :comments_list])
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

      end

      private
      def recipes_params
        params.require(:recipe).permit(:title, :user_id, :description,  :tag_list, :category_id, :time, :persons, :difficult, :steps => [])
      end
    end

  end
end