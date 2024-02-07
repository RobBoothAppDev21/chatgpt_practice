require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "GET /password_resets/new" do
    context "Should return new passwords resets form" do
      it "should redirect if user logged in" do
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        get new_password_resets_path

        expect(response).to redirect_to root_path
      end

      it "should render form if user not logged in" do
        get new_password_resets_path

        expect(rendered).to have_field("Email address")
      end
    end
  end

  describe "POST /password_resets" do
    context "Should submit form" do
      it "should send password email mail if account confirmed" do
        user = create(:user, confirmed_at: Time.zone.now)

        expect { post password_resets_path, params: { user: { email: user.email } } }
          .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
      end

      it "should redirect to root path" do
        user = create(:user, confirmed_at: Time.zone.now)
        post password_resets_path, params: { user: { email: user.email } }

        expect(response).to redirect_to root_path
      end
    end

    context "should redirect" do
      it "to confirmation if account exists but not confirmed" do
        user = create(:user)
        post password_resets_path, params: { user: { email: user.email } }

        expect(response).to redirect_to new_confirmation_path
      end

      it "to root_path if user does not exists" do
        create(:user)
        post password_resets_path, params: { user: { email: "another_user@gmail.com" } }

        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /password_resets/edit" do
    context "should visit passwords_reset after clicking email link" do
      it "should have valid password reset token and let user update email" do
        user = create(:user, confirmed_at: Time.zone.now)
        password_reset_token = user.generate_token_for(:reset_password)

        get edit_password_resets_path, params: { password_reset_token: }

        expect(rendered).to have_field("New Password")
        expect(rendered).to have_field("Confirm New Password")
      end

      it "should to new password reseet page if token invalid or user not found" do
        user = create(:user, confirmed_at: Time.zone.now)
        user.generate_token_for(:reset_password)

        get edit_password_resets_path, params: { password_reset_token: "wrong_token" }

        expect(response).to redirect_to new_password_resets_path
      end
    end
  end

  describe "PUT /passwords_resets" do
    context "should update password" do
      it "change the users password if password is valid and account confirmed" do
        user = create(:user, confirmed_at: Time.zone.now)
        password_reset_token = user.generate_token_for(:reset_password)
        new_password = "updated_password"

        put password_resets_path,
            params: {
              password_reset_token:,
              user: {
                password: new_password, password_confirmation: new_password
              }
            }

        expect(response).to redirect_to login_path
      end

      it "redirect to new confirmation if account not confirmed" do
        user = create(:user)
        password_reset_token = user.generate_token_for(:reset_password)
        new_password = "updated_password"

        put password_resets_path,
            params: {
              password_reset_token:,
              user: {
                password: new_password, password_confirmation: new_password
              }
            }

        expect(response).to redirect_to new_confirmation_path
      end

      it "it should render password reset edit page" do
        user = create(:user, confirmed_at: Time.zone.now)
        password_reset_token = user.generate_token_for(:reset_password)
        new_password = "updated_password"

        put password_resets_path,
            params: {
              password_reset_token:,
              user: {
                password: new_password, password_confirmation: "different_password"
              }
            }

        expect(rendered).to have_field("New Password")
        expect(rendered).to have_field("Confirm New Password")
      end

      it "it should new password reset page" do
        user = create(:user, confirmed_at: Time.zone.now)
        user.generate_token_for(:reset_password)
        new_password = "updated_password"

        put password_resets_path,
            params: {
              password_reset_token: "wrong_token",
              user: {
                password: new_password, password_confirmation: "different_password"
              }
            }

        expect(rendered).to have_field("Email address")
      end
    end
  end
end
