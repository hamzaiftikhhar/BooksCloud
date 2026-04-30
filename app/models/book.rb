class Book < ApplicationRecord
  belongs_to :author
  has_many :borrowings
  has_many :members, through: :borrowings
end
