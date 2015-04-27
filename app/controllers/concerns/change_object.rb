module ChangeObject

  def changed_object
    @step || @comment || @recipe ||  @news ||  @category
  end
end