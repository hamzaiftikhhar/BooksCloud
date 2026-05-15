class ReturnService
  def initialize(borrowing:)
    @borrowing = borrowing
    @return_date = Date.current
  end

  def execute
    validate_return
    process_return
  end

    private

    def validate_return
      raise Borrowing::ReturnError, "Borrowing must be active" unless @borrowing.active?
    end

    def process_return
      overdue = @borrowing.overdue?

      Borrowing.transaction do
        @borrowing.mark_as_returned(Time.current)
        @borrowing.book.increase_available_copy_count(count = 1)
        create_fine if overdue
        @borrowing
      end

    end

    def create_fine
      fine_amount = FineCalculationService.call(borrowing: @borrowing)

      return if fine_amount.zero?

      Fine.create!(
        borrowing: @borrowing,
        amount_due: fine_amount,
        status: :outstanding
      )
    end
end
