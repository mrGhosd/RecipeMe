class PasswordsController < Devise::PasswordsController
  respond_to :html, :json
  skip_authorize_resource
end
