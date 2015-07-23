module Api
  module V1
    class CategoriesController <Api::ApiController
      def index
        render json: Category.all.as_json, status: :ok
      end
    end
  end
end