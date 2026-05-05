class Author < ApplicationRecord
  has_many :books

  validates :first_name, presence: true, length: { minimum: 1, maximum: 255 }, uniqueness: true
  validates :last_name, presence: true, length: { minimum: 1, maximum: 255 }, uniqueness: true
end
