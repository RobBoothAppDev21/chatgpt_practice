# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Please check your email for confirmation instructions."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(params[:id])
  end

  def edit
  end

  def update
    if current_user.update(update_user_params)
      current_user.send_confirmation_email!
      redirect_to root_path, notice: "Please check your new email for update instructions."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user)
          .permit(:unconfirmed_email, :password_challenge)
          .with_defaults(password_challenge: "")
  end
end
