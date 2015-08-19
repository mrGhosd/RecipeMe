class Comment <ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :user

  validates :text, presence: true
  after_create :update_comment

  include RateModel
  include CommentsConcern

  def as_json(params = {})
    super({methods: [:user, :recipe]}.merge(params))
  end

  def self.send_recipe_author_message(comment)
    CommentsMailer.create_message(comment, comment.recipe, comment.recipe.user).deliver
  end

  def update_comment
    Journal.create(user: {id: self.user.id, name: self.user.correct_naming,
    avatar_url: self.user.avatar.url}, event_type: "create", entity: self.class.to_s,
    object: self.attributes, parent_object: self.recipe.attributes.merge({image: self.recipe.image.attributes.merge({url: self.recipe.image.name.url})}),
    created_at: self.created_at)
  end

end