module Queries
  class MostBorrowedBooksQuery
    def self.call(limit = 10)
      new.execute(limit)
    end

    def execute(limit = 10)
      Book.joins(:borrowings)
          .group("books.id")
          .select("books.*, COUNT(borrowings.id) as borrow_count")
          .order("borrow_count DESC")
          .limit(limit)
    end
  end
end
