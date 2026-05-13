class Borrowing < ApplicationRecord
  belongs_to :member
  belongs_to :book
  has_many :fines, dependent: :destroy

  enum :status, { active: 0, returned: 1 }

  validates :member_id, :book_id, presence: true
  validates :status, presence: true
  validates :due_date, presence: true, on: :update
  scope :active, -> { where(status: statuses[:active]) }
  scope :returned, -> { where(status: statuses[:returned]) }
  scope :overdue, -> { active.where("return_date IS NULL AND due_date < ? OR return_date > due_date", Date.current) }
  before_create :set_issue_date
  before_create :set_due_date # is this callback or validation?

  def overdue?
    return false unless due_date.present?

    if return_date.present?
      return return_date.to_date > due_date.to_date
    end

    Date.current > due_date
  end

  def days_overdue
    return 0 unless due_date.present?

    end_date = return_date&.to_date || Date.current
    due = due_date.to_date
    binding
    return 0 if end_date <= due

    (end_date - due).to_i
  end

  def mark_as_returned(returned_date = Time.current)
    update!(status: :returned, return_date: returned_date)
  end

  def borrowing_history
    {
      member: member.name,
      book: book.title,
      issue_date: issue_date&.to_date,
      due_date: due_date,
      returned_date: return_date&.to_date,
      status: status,
      overdue: overdue?
    }
  end

  private

  def set_issue_date
    self.issue_date ||= Time.current
  end

  def set_due_date
    self.due_date ||= Date.current + LibraryConstants::LOAN_PERIOD_DAYS.days
  end
end
