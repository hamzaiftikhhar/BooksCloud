class FineCalculationService
  def self.call(borrowing:)
    new(borrowing: borrowing).execute
  end

    def initialize(borrowing:)
      @borrowing = borrowing
    end

    def execute
      return 0 unless @borrowing.due_date.present?

      actual_return_date = (@borrowing.return_date || Date.current).to_date
      due_date = @borrowing.due_date.to_date

      overdue_days = (actual_return_date - due_date).to_i

      overdue_days * LibraryConstants::FINE_PER_DAY
    end

    
end
