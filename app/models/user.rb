class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]
  mount_uploader :avatar, AvatarUploader
  has_many :recipes
  has_many :comments
  has_many :votes
  has_many :authorizations
  has_many :relationships, foreign_key: "follower_id",
           dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
           :class_name => "Relationship",
           :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  include Rate

  after_create :set_nickname

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(followed_id: followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  def following_list
    self.followers.order(name: :asc).limit(6)
  end

  def followers_list
    self.following.order(name: :asc).limit(6)
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

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.find_by email: email
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
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


  private

  def set_nickname
    nick_arr = self.email.partition("@")
    self.update(nickname: nick_arr[0])
  end
end
