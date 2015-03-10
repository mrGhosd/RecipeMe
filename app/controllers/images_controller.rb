class ImagesController < ApplicationController
  def create
    if params[:imageable_id].blank?
      image = Image.create(image_params)
      render json: image.as_json(only: [:id, :name])
    else
      image = Image.find_by(imageable_type: params[:imageable_type], imageable_id: params[:imageable_id] )
      if image
        image.update(name: params[:name])
      end
    end
    head :ok
  end

  private
  def image_params
    params.permit(:imageable_id, :imageable_type, :name)
  end
end