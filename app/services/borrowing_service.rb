module Services
  class BorrowingService
    def initialize(member:, book:)
      @member = member
      @book = book
    end

    def execute
      validate_borrowing
      create_borrowing
    end

    private

    def validate_borrowing
      # raise Borrowing::MemberSuspendedError if @member.suspended?
      raise Borrowing::MemberExpiredError if @member.expired?
      raise Borrowing::BorrowLimitReachedError if @member.active_borrowings.count >= @member.borrow_limit
      raise Borrowing::NoAvailableCopiesError unless @book.copy_available?
    end

    def create_borrowing
      Borrowing.transaction do
        borrowing = Borrowing.create!(
          member: @member,
          book: @book,
          status: "active"
        )

        @book.decrease_available_copies
        borrowing
      end
    end
  end
end
