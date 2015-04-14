module Images
  include ChangeObject

  def create_image
    if params[:image].present? && (params[:image][:image_id].present? || params[:image][:id].present? )
      Image.find(params[:image][:image_id] || params[:image][:id]).update(imageable_id: changed_object.id)
      changed_object.update_image
    end
  end
end