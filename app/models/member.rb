class Member < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  has_many :books, through: :borrowings
has_many :fines, through: :borrowings, source: :fines

  enum :status, { active: 0, suspended: 1, expired: 2 }

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, length: { minimum: 10, maximum: 20 }
  validates :membership_number, presence: true, uniqueness: true
  validates :max_books_allowed, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

before_validation :generate_membership_number, on: :create
before_validation :set_default_borrow_limit, on: :create
before_validation :set_default_status, on: :create

  scope :active, -> { where(status: statuses[:active]) }
  scope :suspended, -> { where(status: statuses[:suspended]) }
  scope :expired, -> { where(status: statuses[:expired]) }

  def active_borrowings
    borrowings.active
  end

  def borrow_limit
    max_books_allowed
  end

  def overdue_borrowings
    active_borrowings.where("due_date < ?", Date.current)
  end

  def can_borrow?
    active? && active_borrowings.count < max_books_allowed
  end

  private

  def generate_membership_number
    self.membership_number = "MEM#{Time.current.strftime('%Y%m%d%H%M%S')}#{SecureRandom.hex(4)}"
  end

  def set_default_borrow_limit
    self.max_books_allowed ||= LibraryConstants::DEFAULT_BORROW_LIMIT ||= 3
  end

  def set_default_status
    self.status ||= statuses[:active]
  end
end
