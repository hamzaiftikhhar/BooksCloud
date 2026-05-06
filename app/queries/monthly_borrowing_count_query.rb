  class MonthlyBorrowingCountQuery
    def self.call(year = Date.current.year)
      new.execute(year)
    end

    def execute(year)
      start_date = Date.new(year, 1, 1)
      end_date = Date.new(year, 12, 31)

      borrowings = Borrowing.where(created_at: start_date..end_date)

      result = {}
      (1..12).each do |month|
        month_name = Date.new(year, month, 1).strftime("%B")
        count = borrowings.select do |b|
          b.created_at.month == month
        end.length

        result[month_name] = count
      end

      result
    end
  end
