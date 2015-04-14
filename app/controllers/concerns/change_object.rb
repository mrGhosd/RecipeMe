module ChangeObject

  def changed_object
    @object ||= @recipe || @comment || @news
  end

end