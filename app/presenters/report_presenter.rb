class ReportPresenter
  def initialize
    @most_borrowed_books = MostBorrowedBooksQuery.call(10)
    @overdue_members = OverdueBorrowsQuery.call
    @monthly_borrowing_count = MonthlyBorrowingCountQuery.call
  end

  def most_borrowed_books
    @most_borrowed_books.map do |book|
      {
        title: book.title,
        author: book.author.name,
        isbn: book.isbn,
        borrow_count: book.borrow_count
      }
    end
  end

  def overdue_members
    @overdue_members.map do |member|
      {
        name: member.name,
        email: member.email,
        membership_number: member.membership_number,
        overdue_count: member.overdue_borrowings.count
      }
    end
  end

  def financial_summary
    outstanding_fines = Fine.outstanding.sum(:amount_due)
    paid_fines = Fine.paid.sum(:amount_paid)

    {
      outstanding_fines: outstanding_fines || 0,
      paid_fines: paid_fines || 0,
      total_fines: (outstanding_fines || 0) + (paid_fines || 0)
    }
  end

  def monthly_borrowing_data
    @monthly_borrowing_count
  end
end
