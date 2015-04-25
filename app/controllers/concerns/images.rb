module Images
  include ChangeObject

  def create_image
    binding.pry
    if params[:image].present? && (params[:image][:image_id].present? || params[:image][:id].present? )
      Image.find(params[:image][:image_id] || params[:image][:id]).update(imageable_id: changed_object.id)
      changed_object.update_image
      send_image_message
    end
  end

  def send_image_message
    parent = changed_object.try(:recipe).present? ? changed_object.recipe : changed_object
    msg = { resource: changed_object.class.to_s,
            action: 'image',
            id: parent.id,
            obj: changed_object,
            image: changed_object.image
    }

    $redis.publish 'rt-change', msg.to_json
  end
end