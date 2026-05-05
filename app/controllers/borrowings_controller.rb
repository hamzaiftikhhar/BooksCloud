class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: %i[show return_book]

  def index
    @borrowings = policy_scope(Borrowing).includes(:member, :book).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def create
    member = Member.find(params[:member_id])
    book = Book.find(params[:book_id])

    borrowing = Services::BorrowingService.new(member: member, book: book).execute
    redirect_to borrowing, notice: "Book issued successfully."
  rescue StandardError => e
    redirect_back fallback_location: borrowings_path, alert: e.message
  end

  def return_book
    Services::ReturnService.new(borrowing: @borrowing).execute
    redirect_to @borrowing, notice: "Book return recorded successfully."
  rescue StandardError => e
    redirect_to @borrowing, alert: e.message
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end
end
