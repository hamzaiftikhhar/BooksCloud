class Fine < ApplicationRecord
  belongs_to :borrowing
  delegate :member, :book, to: :borrowing

  enum :status, { outstanding: "outstanding", paid: "paid" } # this is also string in database

  validates :borrowing_id, :amount_due, :status, presence: true
  validates :amount_due, numericality: { greater_than: 0 }
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # scope :outstanding, -> { where(status: :outstanding) }
  # scope :paid, -> { where(status: :paid) }

  def mark_as_paid(amount_paid = amount_due)
    raise "Fine is already paid" if paid?
    update!(status: :paid, amount_paid: amount_paid)
  end

  def outstanding_amount
    amount_due - (amount_paid || 0)
  end

  def fully_paid?
    paid? && amount_paid >= amount_due
  end
end
