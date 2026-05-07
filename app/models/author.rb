class Author < ApplicationRecord
  has_many :books

  validates :first_name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :first_name, uniqueness: { scope: :last_name, message: "and last name combination already exists" }


  def name
    "#{first_name} #{last_name}"
  end
end
