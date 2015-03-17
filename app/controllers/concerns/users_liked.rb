module UsersLiked
  include ChangeObject

  def liked_users
    users = Vote.users(@@object.id, @@object.class.to_s)
    render json: users.to_json
  end
end