# frozen_string_literal: true

module RequestHelpers
  def login_as(user, remember_user: nil)
    post("/login", params: {
      user: { 
          email: user.email,
          password: user.password,
          remember_me: remember_user == true ? 1 : 0
        }
      }
    )
  end

  def current_user
    if session[:user_id].present?
      User.find_by(id: session[:user_id])
    elsif cookies[:remember_token]
      User.find_by(id: cookies[:remember_token])
    end
  end

  def rendered
    Capybara.string(response.body)
  end
end