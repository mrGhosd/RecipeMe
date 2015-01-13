require 'capybara/rails'

def sign_in(user)
  visit "/"
  find(".login-window").click
  within find(".login-form", match: :first) do
    fill_in 'user_email', with: user.email
    sleep 1
    fill_in 'user_password', with: user.password
    sleep 1
  end
  find(".send-data").click
end