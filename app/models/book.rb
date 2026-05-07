class Book < ApplicationRecord
  belongs_to :author
  has_many :borrowings, dependent: :destroy
  has_many :members, through: :borrowings
  has_many :fines, through: :borrowings

  has_rich_text :description

  has_one_attached :cover


  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :isbn, presence: true, uniqueness: true, format: { with: /\A(?:\d{9}[\dX]|\d{13})\z/,
                             message: "must be a valid ISBN format (ISBN-10 or ISBN-13)" }

  validate :description_presence

  def description_presence
    if description.blank? || description.body.to_plain_text.strip.blank?
      errors.add(:description, "can't be blank")
    end
  end

  validates :publication_date, presence: true
  validates :total_copy_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :available_copy_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # validate :isbn_format

  # def isbn_format
  #   return if isbn.blank?

  #   # Remove any hyphens or spaces
  #   clean_isbn = isbn.gsub(/[-\s]/, "")

  #   if clean_isbn.match?(/\A\d{13}\z/) && (clean_isbn.start_with?("978") || clean_isbn.start_with?("979"))
  #     # ISBN-13 validation
  #     # Simple check: all digits
  #     unless clean_isbn.match?(/\A\d{13}\z/)
  #       errors.add(:isbn, "ISBN-13 must be 13 digits")
  #     end
  #   elsif clean_isbn.match?(/\A\d{9}[\dX]\z/)
  #     # ISBN-10 validation
  #     # Last character can be X
  #     unless clean_isbn.match?(/\A\d{9}[\dX]\z/)
  #       errors.add(:isbn, "ISBN-10 must be 10 characters (digits or X)")
  #     end
  #   else
  #     errors.add(:isbn, "ISBN must be 10 or 13 digits, starting with 978 or 979 for ISBN-13")
  #   end
  # end

  validate :publication_date_not_in_future

  def publication_date_not_in_future
    if publication_date.present? && publication_date > Date.current
      errors.add(:publication_date, "cannot be in the future")
    end
  end

  validate :available_copy_count_valid


  enum :genre, {
  fiction: 0,
  non_fiction: 1,
  mystery: 2,
  thriller: 3,
  fantasy: 4,
  science_fiction: 5,
  romance: 6,
  horror: 7,
  biography: 8,
  autobiography: 9,
  history: 10,
  self_help: 11,
  business: 12,
  philosophy: 13,
  poetry: 14,
  children: 15,
  young_adult: 16,
  religion: 17,
  science: 18,
  technology: 19
}

validates :genre, presence: true

  def available_copy_count_valid
    return unless available_copy_count.present? && total_copy_count.present?

    if available_copy_count > total_copy_count
      errors.add(:available_copy_count, "cannot exceed total copies")
    end

    if available_copy_count < 0
      errors.add(:available_copy_count, "cannot be negative")
    end
  end

  def copy_available?
    available_copy_count.positive?
  end

  def decrease_available_copy_count(count = 1)
    update!(available_copy_count: available_copy_count - count)
  end

  def increase_available_copy_count(count = 1)
    update!(available_copy_count: available_copy_count + count)
  end
end
