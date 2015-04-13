class SessionsController < Devise::SessionsController
  respond_to :html, :json
  skip_authorize_resource
end
