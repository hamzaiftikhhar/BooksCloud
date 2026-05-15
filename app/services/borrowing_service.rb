class BorrowingService
  def initialize(member:, book:)
    @member = member
    @book = book
  end

  def execute
    validate_borrowing!

    Borrowing.transaction do
      borrowing = create_borrowing!
      update_book_inventory!
      borrowing
    end
  end

  private

  def validate_borrowing!
    raise MemberSuspendedError if @member.suspended?
    raise MemberExpiredError if @member.expired?

    if @member.active_borrowings.size >= @member.max_books_allowed
      raise BorrowLimitReachedError
    end

    raise NoAvailableCopiesError unless @book.copy_available?
  end

  def create_borrowing!
    Borrowing.create!(
      member: @member,
      book: @book,
      status: :active,
      issue_date: Date.current,
      due_date: Date.current + LibraryConstants::LOAN_PERIOD_DAYS.days
    )
  end

  def update_book_inventory!
    @book.decrease_available_copy_count(count = 1)
  end

  # Service-level errors (BEST PRACTICE)
  class MemberSuspendedError < StandardError; end
  class MemberExpiredError < StandardError; end
  class BorrowLimitReachedError < StandardError; end
  class NoAvailableCopiesError < StandardError; end
end
