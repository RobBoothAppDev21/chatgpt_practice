# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation
    mail to: params[:user].email, subject: "Confirmation Instructions"
  end
end
