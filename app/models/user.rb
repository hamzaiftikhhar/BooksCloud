class User < ApplicationRecord
  include Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { librarian: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  # def admin?
  #   role == "admin"
  # end

  # def librarian?
  #   role == "librarian"
  # end
end
