# encoding: utf-8

class RecipeUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end
  version :small do
    process :resize_to_fit => [200,200]
  end

  version :normal do
    process :resize_to_fit => [450,450]
  end

end
