module Images
  include ChangeObject

  def create_image
    if params[:image].present? && (params[:image][:image_id].present? || params[:image][:id].present? )
      Image.find(params[:image][:image_id] || params[:image][:id]).update(imageable_id: changed_object.id)
      changed_object.update_image
      send_image_message
    end
  end

  def send_image_message
    msg = { resource: changed_object.class.to_s,
            action: 'image',
            id: changed_object.id,
            obj: changed_object,
            image: changed_object.image
    }

    $redis.publish 'rt-change', msg.to_json
  end
end