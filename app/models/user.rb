class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { librarian: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
end
