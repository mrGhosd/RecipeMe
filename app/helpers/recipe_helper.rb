module RecipeHelper
  def get_image(obj)
    obj.image.url(:normal)
  end
end