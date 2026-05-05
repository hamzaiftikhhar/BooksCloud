class BorrowingHistoryController < ApplicationController
  before_action :set_member

  def index
    @borrowings = @member.borrowings.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
  end
end
