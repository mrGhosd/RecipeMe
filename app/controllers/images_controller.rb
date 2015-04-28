class ImagesController < ApplicationController
  def create
    if params[:imageable_id].blank?
      image = Image.create(image_params)
      render json: image.as_json(only: [:id, :name]), status: :ok
    else
      image = Image.find_by(imageable_type: params[:imageable_type], imageable_id: params[:imageable_id] )
      if image
        image.update(name: params[:name])
        render json: image.as_json(only: [:imageable_id, :name]), status: :ok
      end
    end
  end

  private

  def image_params
    params.permit(:imageable_id, :imageable_type, :name)
  end
end