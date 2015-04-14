module ChangeObject

  def changed_object
    @step || @recipe || @comment || @news
  end

end