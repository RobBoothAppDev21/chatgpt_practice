require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "should render sign_up page if user is not signed in" do
      get "/sign_up"
      expect(response.status).to eql(200)
    end

    it "should include a sign up from requesting email and password" do
      get "/sign_up"
      expect(rendered).to have_field("Email")
      expect(rendered).to have_field("Password")
      expect(rendered).to have_field("Confirm Password")
    end

    it "should redirect to root page if user signed in" do
      user = create(:user, confirmed_at: Time.zone.now)
      login_as(user)
      get "/sign_up"
      expect(response).to redirect_to root_path
    end
  end

  describe "post /sign_up" do
    context "when user account is invalid" do
      it "should render status 422 uprocessable entity if account exists and password is valid" do
        user = create(:user)
        params = { email: user.email, password: user.password, password_confirmation: user.password }
        post "/sign_up", params: { user: params }

        expect(response).to have_http_status(422)
      end

      it "should rerender sign up if passwords do not match" do
        params = { email: "test_user@gmail.com", password: "password", password_confirmation: "different" }
        post "/sign_up", params: { user: params }

        expect(rendered).to have_css("ul#error-messages")
      end
    end

    context "when user account does not exists" do
      it "should create a new user account" do
        params = { email: "test_user@gmail.com", password: "password", password_confirmation: "password" }
        post "/sign_up", params: { user: params }

        expect(response).to redirect_to root_path
      end

      it "should send a confirmation mail when saved" do
        params = { email: "test_user@gmail.com", password: "password", password_confirmation: "password" }

        expect { post "/sign_up", params: { user: params } }
          .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
      end
    end
  end

  describe "get /account" do
    context "When user visit /account to update email" do
      it "should render form with email and password challenge" do
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        get "/account/edit"

        expect(rendered).to have_field("Enter new email address")
        expect(rendered).to have_field("Confirm password")
      end
    end
  end

  describe "post /account" do
    context "when user submits new email address with valid inputs" do
      it "should update unconfirmed email attributes" do
        new_email = "updated_email@test.com"
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        params = { unconfirmed_email: new_email, password_challenge: user.password }
        put "/account", params: { user: params }

        expect(user.reload.unconfirmed_email).to eql(new_email)
        expect(user.reload.confirmed_at).to be_nil
      end

      it "should send an confirmation email" do
        new_email = "updated_email@test.com"
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        params = { unconfirmed_email: new_email, password_challenge: user.password }

        expect { put "/account", params: { user: params } }
          .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
      end

      it "should redirect to homepage" do
        new_email = "updated_email@test.com"
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        params = { unconfirmed_email: new_email, password_challenge: user.password }
        put "/account", params: { user: params }

        expect(response).to redirect_to root_path
      end
    end

    context "when a user submits new email with invalid inputs" do
      it "should rerender the edit page if wrong password" do
        new_email = "updated_email@test.com"
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        params = { unconfirmed_email: new_email, password_challenge: "wrong_password" }
        put "/account", params: { user: params }

        expect(rendered).to have_field("Enter new email address")
        expect(rendered).to have_field("Confirm password")
      end
    end
  end

  describe "get /profiles" do
    it "should signed in user profile" do
      user = create(:user, confirmed_at: Time.zone.now)
      login_as(user)
      get "/profile"

      expect(response.status).to be(200)
    end

    it "should redirect to home if user is not signed or current_user" do
      create(:user, confirmed_at: Time.zone.now)
      get "/profile"

      expect(response).to redirect_to login_path
    end
  end
end
