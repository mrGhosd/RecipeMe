class PasswordsController < Devise::PasswordsController
  respond_to :json
  skip_authorize_resource
end
