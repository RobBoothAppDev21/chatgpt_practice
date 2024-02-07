require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "should visit login page if user not logged in" do
      create(:user, confirmed_at: Time.zone.now)
      get login_path

      expect(rendered).to have_field("Email address")
      expect(rendered).to have_field("Password")
    end

    it "should redirect to root if user already logged in" do
      user = create(:user, confirmed_at: Time.zone.now)
      login_as(user)
      get login_path

      expect(response).to redirect_to root_path
    end
  end

  describe "POST /login" do
    it "should log in user with vaild credentials and confirmed account" do
      user = create(:user, confirmed_at: Time.zone.now)
      params = { user: { email: user.email, password: user.password } }
      post(login_path, params:)

      expect(response).to redirect_to root_path
    end

    it "should render confirmations page if account not confirmed" do
      user = create(:user)
      params = { user: { email: user.email, password: user.password } }
      post(login_path, params:)

      expect(response).to redirect_to new_confirmation_path
    end

    it "should render login page if credentials invalid" do
      user = create(:user)
      params = { user: { email: user.email, password: "wrong_password" } }
      post(login_path, params:)

      expect(rendered).to have_field("Email address")
      expect(rendered).to have_field("Password")
    end
  end

  describe "DELETE /login" do
    it "should redirect to root if user not logged in" do
      delete login_path

      expect(response).to redirect_to login_path
    end

    it "should sign out current user" do
      user = create(:user, confirmed_at: Time.zone.now)
      login_as user
      expect(session[:current_user_id]).to eq(user.id)
      delete login_path

      expect(session[:current_user_id]).to be_nil
    end
  end
end
