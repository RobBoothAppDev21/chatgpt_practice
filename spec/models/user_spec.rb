require 'rails_helper'

RSpec.describe User, type: :model do
  context "when a valid new user is created" do
    it "should normalize the email address" do
      user = create(:user, email: "TEST_user@gmail.com ")

      expect(user.email).to eq("test_user@gmail.com")
    end

    it "should encrypt the password" do
      user = create(:user, password: "test_password", password_confirmation: "test_password")

      expect(user).to respond_to(:password_digest)
    end

    it "should authenticate the user" do
      user = create(:user)

      expect(user.authenticate("password")).to eq(user)
    end

    it "should be unconfirmed" do
      user = create(:user)

      expect(user.unconfirmed?).to be
    end

    it "should have a remember token" do
      user = create(:user)

      expect(user.remember_token).to be
    end

    it "should not have an unconfirmed email" do
      user = create(:user)

      expect(user.unconfirmed_email).to be_nil
    end

    it "should not have a confirmed time" do
      user = create(:user)

      expect(user.confirmed_at).to be_nil
    end
  end

  context "when a not valid user is created" do
    it "should not create user when email is blank" do
      user = build(:user, email: "")

      expect(user).not_to be_valid
    end

    it "should reject an account with a duplicate email" do
      create(:user)
      user = build(:user)

      expect(user).not_to be_valid
    end

    it "should not create user when email is not a valid format" do
      expect(build(:user, email: "test_user.com")).not_to be_valid
    end

    it "should not create user when password and password confirmation do not match" do
      user = build(:user, password: "password", password_confirmation: "different_password")

      expect(user).not_to be_valid
    end
  end

  context "when a user updates email of a confirmed account" do
    it "normalizes the unconfirmed email before saving" do
      time = Time.zone.now
      user = create(:user, confirmed_at: time)
      user.update(unconfirmed_email: " unconfirmed_TEST@gmail.com   ")

      expect(user.unconfirmed_email).to eq("unconfirmed_test@gmail.com")
    end

    it "returns true for confirmed_at?" do
      time = Time.zone.now
      user = create(:user, confirmed_at: time)

      expect(user.confirmed?).to be
    end
  end

  it "sends a confirmation email" do
    user = create(:user)
    expect { user.send_confirmation_email! }
      .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
  end

  it "sends a password reset email" do
    user = create(:user)
    expect { user.send_password_reset_email! }
      .to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(:once)
  end
end
