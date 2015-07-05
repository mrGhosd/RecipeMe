module Api
  module V1
    class RecipesController < Api::ApiController
      before_action :doorkeeper_authorize!, only: [:create]

      def index
        recipes = Recipe.filter(params).paginate(page: params[:page] || 1, per_page: 12)
        render json: recipes.as_json(methods: [:user, :image])
      end

      def create

      end

      def show
        recipes = Recipe.find(params[:id])
        render json: recipes.as_json(methods: [:user, :image, :steps_list, :ingridients_list, :comments_list])
      end
    end
  end
end