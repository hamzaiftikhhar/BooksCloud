module Services
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
      Borrowing.transaction do
        @borrowing.mark_as_returned(Time.current)
        @borrowing.book.increase_available_copies

        if @borrowing.overdue?
          create_fine
        end

        @borrowing
      end
    end

    def create_fine
      fine_amount = Services::FineCalculationService.call(borrowing: @borrowing)

      if fine_amount > 0
        Fine.create!(
          borrowing: @borrowing,
          amount_due: fine_amount,
          status: "outstanding"
        )
      end
    end
  end
end
