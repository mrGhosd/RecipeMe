class CommentUpdate < UserUpdate

  def recipe
    Comment.find(self.update_id).recipe.as_json(methods: :image)
  end

  def follower_user
    super
  end

  def entity
    Comment.find(self.update_id)
  end

  def as_json(*)
    super(methods: [:recipe, :follower_user, :entity])
  end
end