# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.authenticate_by(sessions_params.slice(:email, :password).to_hash)
    if @user
      if @user.confirmed?
        after_login_path = session[:user_return_to] || root_path
        login @user
        remember(@user) if sessions_params[:remember_me] == "1"
        redirect_to after_login_path, notice: "Signed in."
      else
        redirect_to new_confirmation_path, alert: "Please confirm your account."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget current_user
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

  private

  def sessions_params
    params.require(:user).permit(:email, :password, :remember_me)
  end
end
