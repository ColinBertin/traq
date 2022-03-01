class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :comments, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :locations, through: :contributions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
