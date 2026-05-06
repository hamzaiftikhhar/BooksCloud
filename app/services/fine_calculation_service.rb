class FineCalculationService
  def self.call(borrowing:)
    new(borrowing: borrowing).execute
  end

    def initialize(borrowing:)
      @borrowing = borrowing
    end

    def execute
      return 0 unless @borrowing.due_date.present?

      actual_return_date = @borrowing.return_date&.to_date || Date.current
      overdue_days = (actual_return_date - @borrowing.due_date).to_i
      return 0 if overdue_days <= 0

      overdue_days * LibraryConstants::FINE_RATE_PER_DAY
    end
end
