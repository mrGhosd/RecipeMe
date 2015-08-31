class Journal
  include Mongoid::Document
  include WebsocketsMessage
  include ActiveRecord::Callbacks
  store_in collection: "feeds", database: Rails.application.secrets.mongoid_db, session: "default"
  field :user, type: Hash
  field :event_type, type: String
  field :entity, type: String
  field :parent_object, type: Hash
  field :object, type: Hash
  field :created_at, type: DateTime

  after_create :send_create_message


  private

  def send_create_message
    message({ resource: 'Feed',
              action: 'create',
              id: self.id,
              obj: self
            })
  end
end