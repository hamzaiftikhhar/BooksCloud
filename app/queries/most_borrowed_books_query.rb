class MostBorrowedBooksQuery
    def self.call(limit = 10)
      new.execute(limit)
    end

    def execute(limit = 10)
      Book.joins(:borrowings)
          .select("books.*, COUNT(borrowings.id) as borrow_count")
          .group("books.id")
          .order("borrow_count DESC")
          .limit(limit)
    end
end
