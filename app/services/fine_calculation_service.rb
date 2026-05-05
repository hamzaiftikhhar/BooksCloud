module Services
  class FineCalculationService
    def self.call(borrowing:)
      new(borrowing: borrowing).execute
    end

    def initialize(borrowing:)
      @borrowing = borrowing
    end

    def execute
      return 0 unless @borrowing.overdue?

      days_overdue = @borrowing.days_overdue
      days_overdue * LibraryConstants::FINE_RATE_PER_DAY
    end
  end
end
