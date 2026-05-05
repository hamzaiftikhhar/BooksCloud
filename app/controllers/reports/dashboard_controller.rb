module Reports
  class DashboardController < ApplicationController
    def index
      @presenter = ReportPresenter.new
    end

    def most_borrowed_books
      @presenter = ReportPresenter.new
    end

    def overdue_members
      @presenter = ReportPresenter.new
    end

    def financial_summary
      @presenter = ReportPresenter.new
    end

    def monthly_borrowing
      @presenter = ReportPresenter.new
    end
  end
end
