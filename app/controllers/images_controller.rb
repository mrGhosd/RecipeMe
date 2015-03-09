class ImagesController < ApplicationController
  def create
    if params[:imageable_id].blank?
      image = Image.create(image_params)
      render json: image.as_json(only: [:id, :name])
    end
  end

  private
  def image_params
    params.permit(:imageable_id, :imageable_type, :name)
  end
end