# Preview all emails at http://localhost:3000/rails/mailers/password_reset
class PasswordResetPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/password_reset/password_reset
  def password_reset
    PasswordResetMailer.password_reset
  end

end
