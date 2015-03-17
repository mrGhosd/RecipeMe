module Rate
  include ChangeObject

  def rating
    if @@object.update_rating(current_user)
      render json: {rate: @@object.rate}, status: :ok
    else
      render json: @@object.errors.to_json, status: :uprocessible_entity
    end
  end

  def update_rating(user)
    if user.has_voted?(self)
      user.find_vote(self).try(:destroy)
      self.update(rate: self.rate - 1)
    else
      user.votes.create(voteable_id: self.id, voteable_type: self.class.to_s)
      self.update(rate: self.rate + 1)
    end
  end

  def has_voted?(object)
    !!self.find_vote(object) ? true : false
  end

  def find_vote(object)
    self.votes.find_by(voteable_id: object.id, voteable_type: object.class.to_s)
  end
end