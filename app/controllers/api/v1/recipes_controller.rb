module Api
  module V1
    class RecipesController < ::ApplicationController
      def index
        recipes = Recipe.all.limit(12)
        render json: recipes.as_json(methods: [:user, :image])
      end
    end
  end
end