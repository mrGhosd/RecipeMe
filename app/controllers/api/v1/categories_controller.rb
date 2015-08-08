module Api
  module V1
    class CategoriesController <Api::ApiController
      before_action :load_category, except: :index

      def index
        render json: Category.all.as_json(methods: :image), status: :ok
      end

      def recipes
        render json: @category.recipes.paginate(page: params[:page] || 1, per_page: 12).as_json(methods: [:user, :image, :votes])
      end

      private

      def load_category
        @category = Category.find(params[:id])
      end
    end
  end
end