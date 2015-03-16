module UsersLiked
  def change_object
    @@object = !!@recipe ? @recipe : @comment
  end


  def liked_users

  end

  def voted_users
  end
end