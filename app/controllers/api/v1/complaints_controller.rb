module Api
  module V1
    class ComplainstsController < Api::ApiController
      before_action :doorkeeper_authorize!

      def create
        complaint = Complaint.new(complaint_params)
        if complaint.save
          render nothing: true, status: :ok
        else
          render json: complaint.errors.as_json, status: :unprocessable_entity
        end
      end

      private
      def complaint_params
        params.require(:complaint).permit(:user_id, :complaintable_id, :complaintable_type)
      end
    end
  end
end