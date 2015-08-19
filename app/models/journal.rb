class Journal
  include Mongoid::Document
  Mongoid.raise_not_found_error = false
  store_in collection: "feeds", database: "recipe_me_development", session: "default"
  field :user, type: Hash
  field :event_type, type: String
  field :entity, type: String
  field :parent_object, type: Hash
  field :object, type: Hash
  field :created_at, type: DateTime
end