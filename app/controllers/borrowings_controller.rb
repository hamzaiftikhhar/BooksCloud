class BorrowingsController < ApplicationController
  before_action :set_borrowing, only: %i[show return_book]


  def index
    @borrowings = policy_scope(Borrowing).includes(:member, :book).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def create
    member = Member.find_by(membership_number: borrowing_params[:membership_number])
    raise "Member not found" unless member

    book = Book.find(params[:book_id])

    borrowing = BorrowingService.new(member: member, book: book).execute

    redirect_to borrowing, notice: "Book issued successfully."

  rescue StandardError => e
    redirect_back fallback_location: borrowings_path, alert: e.message
  end

  def search_member
    @member = Member.find_by(membership_number: params[:membership_number])
    @book = Book.find(params[:book_id])

    respond_to do |format|
      format.html { render partial: "member_details", locals: { member: @member, book: @book } }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("member_check", partial: "member_details", locals: { member: @member, book: @book })
      end
    end
  end

  def return_book
    ReturnService.new(borrowing: @borrowing).execute
    redirect_to @borrowing, notice: "Book return recorded successfully."
  rescue StandardError => e
    redirect_to @borrowing, alert: e.message
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find_by(id: params[:id])
  end

  def borrowing_params
    params.require(:borrowing).permit(:membership_number)
  end
end
