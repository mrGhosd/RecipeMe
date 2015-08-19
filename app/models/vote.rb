class Vote < ActiveRecord::Base
  belongs_to :user
  scope :users, -> (id, type) { where(voteable_type: type,
  voteable_id: id).map(&:user_id).map{|u| User.find(u) }.map{|u| u.as_json(only: [:id, :avatar] ) } }
  after_create :update_vote
  after_destroy :destroy_vote

  def update_vote
    object = self.voteable_type.constantize.find(self.voteable_id)
    parent_object = self.voteable_type.eql?("Comment") ? object.recipe.attributes.merge({image: object.recipe.image.attributes.merge({url: object.recipe.image.name.url})}) : object.attributes.merge({image: object.image.attributes.merge({url: object.image.name.url})})
    Journal.create(user:  {id: self.user.id, name: self.user.correct_naming,
                         avatar_url: self.user.avatar.url}, event_type: "create",
                   object: self.attributes, entity: self.class.to_s, user: {id: self.user.id, name: self.user.correct_naming,
                  avatar_url: object.user.avatar.url}, parent_object: parent_object,
                   created_at: self.created_at)
  end

  def destroy_vote
    UserUpdate.where(update_entity: self.class.to_s, update_id: self.voteable_id).destroy_all
  end
end