class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :lockable, :trackable, :omniauthable
end
