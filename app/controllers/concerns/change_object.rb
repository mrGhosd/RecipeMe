module ChangeObject
  def change_object
    @@object = !!@recipe ? @recipe : @comment
  end
end