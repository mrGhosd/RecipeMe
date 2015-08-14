module ImageModel
  def update_image
    current_image = self.image
    last_image = Image.where(imageable_id: self.id).last
    current_image == last_image ? true : self.update(image: last_image) #Добавить удаление предыдущих фотографий!
  end
end