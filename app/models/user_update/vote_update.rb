class VoteUpdate < UserUpdate
  def recipe
    self.update_entity_for.eql?("Comment") ? Comment.find(self.update_id).recipe : nil
  end

  def as_json(*)
    super(methods: :recipe)
  end
end