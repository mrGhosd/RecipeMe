class Vote < ActiveRecord::Base
  belongs_to :user
  scope :users, -> (id, type) { where(voteable_type: type,
  voteable_id: id).map(&:user_id).map{|u| User.find(u) }.map{|u| u.as_json(only: [:id, :avatar] ) } }
end