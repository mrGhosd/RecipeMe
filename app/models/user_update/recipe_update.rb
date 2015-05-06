class RecipeUpdate < UserUpdate
  def entity
    Recipe.find(self.update_id).as_json(methods: :image)
  end

  def follower_user
    super
  end

  def as_json(*)
    super(methods: [:entity, :follower_user])
  end
end