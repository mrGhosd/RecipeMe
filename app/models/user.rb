class User < ActiveRecord::Base
  extend FriendlyId

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter, :vkontakte, :instagram]
  mount_uploader :avatar, AvatarUploader
  friendly_id :nickname, use: [:slugged, :finders]
  has_many :recipes
  has_many :comments
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id",
           dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
           :class_name => "Relationship",
           :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  validates :nickname, presence: true, if: :should_validate?

  include RateModel
  include UsersConcerns

  after_create :set_nickname_and_slug
  after_update :update_journal_info
  after_destroy :destroy_journal_info

  def follow!(followed)
    relationships.create!(followed_id: followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def following_list
    self.following.order(name: :asc).limit(6)
  end

  def followers_list
    self.followers.order(name: :asc).limit(6)
  end

  def following_ids
    self.following.map(&:id)
  end

  def followers_ids
    self.followers.map(&:id)
  end

  def recipes_count
    self.recipes.count
  end

  def comments_count
    self.comments.count
  end

  def is_admin?
    self.role.eql?("admin")
  end

  def correct_naming
    if self.nickname
      "#{self.nickname}"
    elsif self.surname && self.name
      "#{self.surname} #{self.name}"
    else
      "#{self.email}"
    end
  end

  def self.from_omniauth(auth, instagram: false)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.find_by email: email
    if user
      user.create_authorization(auth)
    else
      if instagram
        auth.extra.raw_info = {photo_200_orig: auth.info.image}
        nickname = {nickname: auth.info.nickname}
      end
      password = Devise.friendly_token[0, 20]
      user_params = {email: email, password: password, password_confirmation: password,
                     name: auth.info.first_name, surname: auth.info.last_name,
                     city: auth.info.location}
      user_params = user_params.merge({remote_avatar_url: auth.extra.raw_info.photo_200_orig}) if auth.extra.raw_info.present?
      user_params = user_params.merge({nickname: nickname}) if instagram
      user = User.create!(user_params)
      user.create_authorization(auth)
    end
    user
  end

  def own_feed
    Journal.where("user.id" => self.id).order(created_at: :desc)
  end

  def feed
    Journal.where("user.id" => {'$in' => self.following.map(&:id).push(self.id)}).order(created_at: :desc)
  end

  def self.send_follow_message(user, follower)
    UsersMailer.follow(user, follower).deliver
  end

  def self.send_unfollow_message(user, follower)
    UsersMailer.unfollow(user, follower).deliver
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def last_sign_in_at_h
    self.last_sign_in_at.strftime('%H:%M:%S %d.%m.%Y') if self.last_sign_in_at
  end

  def should_validate?
    !new_record?
  end

  private

  def set_nickname_and_slug
    nick_arr = email.partition("@")
    self.update(nickname: nick_arr[0])
  end

  def update_journal_info
    if self.changed?
      Journal.where("user.id" => self.id).update_all({"user.name" => self.correct_naming,
                                                      "user.avatar_url" => self.avatar.url})
    end
  end

  def destroy_journal_info

  end
end
