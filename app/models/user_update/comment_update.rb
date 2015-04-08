class CommentUpdate < UserUpdate

  def recipe
    Comment.find(self.update_id).recipe
  end

  def as_json(*)
    super(methods: :recipe)
  end
end