module LibraryConstants
  # Borrowing configuration
  LOAN_PERIOD_DAYS = 14
  DEFAULT_BORROW_LIMIT = 3

  # Fine configuration
  FINE_RATE_PER_DAY = 10 # PKR per day overdue

  # Member statuses
  MEMBER_STATUSES = {
    active: "active",
    suspended: "suspended",
    expired: "expired"
  }.freeze # We use freeze because this is a hash and we want to prevent modifications to it at runtime, while the other constants are simple values that don't require freezing.

  # Borrow statuses
  BORROW_STATUSES = {
    active: "active",
    returned: "returned"
  }.freeze

  # Fine statuses
  FINE_STATUSES = {
    outstanding: "outstanding",
    paid: "paid"
  }.freeze
end
