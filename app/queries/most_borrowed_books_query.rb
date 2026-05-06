class MostBorrowedBooksQuery
  def self.call(limit = 5)
    Book.joins(:borrowings)
        .group("books.id")
        .order("COUNT(borrowings.id) DESC")
        .limit(limit)
  end
end
