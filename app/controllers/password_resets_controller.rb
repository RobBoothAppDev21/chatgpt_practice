# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :redirect_if_authenticated

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
      else
        redirect_to new_confirmation_path, alert: "Please confirm your email first."
      end
    else
      redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
    end
  end

  def edit
    @user = User.find_by_token_for(:reset_password, params[:password_reset_token])
    if @user.present? && @user.unconfirmed?
      redirect_to new_confirmation_path, alert: "You must confirm your email first."
    elsif @user.nil?
      redirect_to new_password_path, alert: "Invalid or expired token."
    end
  end

  def update
    @user = User.find_by_token_for(:reset_password, params[:password_reset_token])
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "You must confirm your email first."
      elsif @user.update(password_reset_params)
        redirect_to login_path, notice: "Sign in."
      else
        flash.now[:alert] = @user.errors.full_message.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid or expired token."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
