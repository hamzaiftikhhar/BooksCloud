module Queries
  class OverdueBorrowsQuery
    def self.call
      new.execute
    end

    def execute
      Member.joins(:borrowings)
            .where(borrowings: { status: "active" })
            .where("borrowings.due_date < ?", Date.current)
            .select("DISTINCT members.*")
            .order("members.name")
    end
  end
end
