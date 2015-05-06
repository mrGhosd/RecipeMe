class VoteUpdate < UserUpdate
  def recipe
    self.update_entity_for.eql?("Comment") ? Comment.find(self.update_id).recipe : nil
  end

  def follower_user
    super
  end

  def entity
    self.update_entity_for.constantize.find(self.update_id).as_json(methods: :image)
  end

  def as_json(*)
    super(methods: [:recipe, :follower_user, :entity])
  end
end