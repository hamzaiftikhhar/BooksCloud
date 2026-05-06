class DashboardController < ApplicationController
  def index
    @books_count = Book.count
    @members_count = Member.count
    @active_borrowings_count = Borrowing.active.count
    @overdue_borrowings_count = Borrowing.overdue.count
    @recent_borrowings = Borrowing.includes(:book, :member).order(created_at: :desc).limit(5)
    @recent_books = Book.order(created_at: :desc).limit(5)
    @top_borrowed_books = MostBorrowedBooksQuery.call(5) # from where this is coming? this is a query object that we have created in app/queries/most_borrowed_books_query.rb
  end
end
