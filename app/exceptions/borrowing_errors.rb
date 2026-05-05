module Borrowing
  class BorrowingError < StandardError; end

  class MemberSuspendedError < BorrowingError
    def initialize
      super("This member's account is suspended and cannot borrow books.")
    end
  end

  class MemberExpiredError < BorrowingError
    def initialize
      super("This member's account has expired and cannot borrow books.")
    end
  end

  class BorrowLimitReachedError < BorrowingError
    def initialize
      super("This member has reached their borrow limit.")
    end
  end

  class NoAvailableCopiesError < BorrowingError
    def initialize
      super("No copies of this book are currently available.")
    end
  end

  class ReturnError < StandardError; end

  class BookNotBorrowedError < ReturnError
    def initialize
      super("This book is not currently borrowed by this member.")
    end
  end
end
