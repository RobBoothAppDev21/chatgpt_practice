require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  describe "GET /password/edit" do
    it "redirects to login if user isn't logged in" do
      get edit_password_path
      expect(response).to redirect_to login_path
    end

    it "redirects if user logged in but has unconfirmed account" do
      user = create(:user, confirmed_at: Time.zone.now)
      login_as(user)
      get edit_password_path

      expect(rendered).to have_field("Current Password")
      expect(rendered).to have_field("Enter new password")
      expect(rendered).to have_field("Confirm new password")
    end
  end

  describe "PUT /password" do
    it "updates user password if params are valid" do
      user = create(:user, confirmed_at: Time.zone.now)
      password = password_confirmation = "new_password"
      login_as(user)
      params = {
        user: {
          password_challenge: user.password, password:, password_confirmation:
        }
      }
      put(password_path, params:)

      expect(response).to redirect_to root_path
      expect(user.reload.authenticate(password)).to be
    end

    it "does not update user password if params are invalid" do
      user = create(:user, confirmed_at: Time.zone.now)
      password = "new_password"
      login_as(user)
      params = {
        user: {
          password_challenge: user.password, password:, password_confirmation: "wrong_password"
        }
      }
      put(password_path, params:)

      expect(rendered).to have_field("Current Password")
      expect(rendered).to have_field("Enter new password")
      expect(rendered).to have_field("Confirm new password")
    end
  end
end
