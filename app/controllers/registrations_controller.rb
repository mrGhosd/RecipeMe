class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  skip_authorize_resource
end
