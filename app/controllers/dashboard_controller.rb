class DashboardController < ApplicationController
  def index
    @books = Book.all
    @books_count = Book.count
    @members_count = Member.count
    @active_borrowings_count = Borrowing.active.count
    if @active_borrowings_count > 0
      @overdue_borrowings_count = Borrowing.overdue.count
    else
      @overdue_borrowings_count = 0
    end
  end
end
