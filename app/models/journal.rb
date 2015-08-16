class Journal
  include Mongoid::Document
  store_in collection: "feeds", database: "recipe_me_development", session: "default"
  field :user, type: Hash
  field :entity, type: Hash
  field :created_at, type: DateTime
end