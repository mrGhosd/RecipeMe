module ChangeObject
  def change_object
    @@object = if !!@recipe
                 @recipe
               elsif !!@comment
                 @comment
               elsif !!@news
                 @news
               end
  end
end