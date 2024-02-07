require "rails_helper"

RSpec.describe PasswordMailer, type: :mailer do
  describe "password_reset" do
    it "renders the headers" do
      user = create(:user, confirmed_at: Time.zone.now)
      password_reset_token = user.generate_token_for(:reset_password)
      mail = PasswordMailer.with(user:, password_reset_token:).password_reset
      expect(mail.subject).to eq("Password Reset Instructions.")
      expect(mail.to).to eq([user.email])
      # expect(mail.from).to eq(["from@example.com"])
    end

    # it "renders the body"
      # expect(mail.body.encoded).to match("Hi")
  end
end
