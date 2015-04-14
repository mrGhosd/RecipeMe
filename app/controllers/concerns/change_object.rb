module ChangeObject

  def changed_object
    @step || @recipe || @comment || @news ||  @category || @news
  end

end