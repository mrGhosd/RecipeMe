module UsersLiked
  include ChangeObject

  def liked_users
    users = Vote.users(changed_object.id, changed_object.class.to_s)
    render json: users.to_json
  end
end