require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "confirmation" do
    it "renders the headers" do
      user = create(:user)
      confirmation_token = user.generate_token_for(:confirm_email)
      mail = UserMailer.with(user:, confirmation_token:).confirmation
      expect(mail.subject).to eq("Confirmation Instructions.")
      expect(mail.to).to eq([user.email])
    end
  end
end
