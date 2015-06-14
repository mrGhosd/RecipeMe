module Api
  module V1
    class RecipesController < ::ApplicationController
      before_action :doorkeeper_authorize!, only: [:create]

      def index
        recipes = Recipe.filter(params).paginate(page: params[:page] || 1, per_page: 12)
        render json: recipes.as_json(methods: [:user, :image])
      end

      def create

      end
    end
  end
end