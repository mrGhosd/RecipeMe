class Vote < ActiveRecord::Base
  belongs_to :user
  scope :users, -> (id, type) { where(voteable_type: type,
  voteable_id: id).map(&:user_id).map{|u| User.find(u) }.map{|u| u.as_json(only: [:id, :avatar] ) } }
  after_create :update_vote

  def update_vote
    VoteUpdate.create(user_id: self.user.id, update_type: 'create', update_entity: self.class.to_s, update_entity_for: self.voteable_type, update_id: self.voteable_id)
  end
end