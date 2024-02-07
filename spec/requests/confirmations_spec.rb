require 'rails_helper'

RSpec.describe "Confirmations", type: :request do
  describe "GET /confirmations/new" do
    context "when visiting new confirmation page" do
      it "should render new page to send confirmation email" do
        get "/confirmations/new"

        expect(rendered).to have_field("Email address")
      end

      it "should redirect to home if user logged in" do
        user = create(:user, confirmed_at: Time.zone.now)
        login_as(user)
        get "/confirmations/new"

        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST /confirmations" do
    context "when sending confirmation with valid user" do
      it "should send confirmation mail" do
        user = create(:user)
        params = { user: { email: user.email } }

        expect { post "/confirmations", params: }
          .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
      end

      it "should redirect user to root path" do
        user = create(:user)
        params = { user: { email: user.email } }
        post("/confirmations", params:)

        expect(response).to redirect_to root_path
      end
    end

    context "when sending confirmation with invalid user" do
      it "should redirect to new confirmation" do
        create(:user)
        params = { user: { email: "wrong_email@gmail.com"} }
        post("/confirmations", params:)

        expect(response).to redirect_to new_confirmation_path
      end
    end
  end

  describe "GET /confirmations/:confirmation_token/edit" do
    context "when confirming accounts with token" do
      it "should update confirmed_at attribute" do
        user = create(:user)
        confirmation_token = user.generate_token_for(:confirm_email)
        get edit_confirmation_path(confirmation_token)

        expect(user.reload.confirmed?).to be
      end

      it "should update redirect to root after confirming account" do
        user = create(:user)
        confirmation_token = user.generate_token_for(:confirm_email)
        get edit_confirmation_path(confirmation_token)

        expect(response).to redirect_to root_path
      end
    end
  end
end
