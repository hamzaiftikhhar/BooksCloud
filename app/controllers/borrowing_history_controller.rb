class BorrowingHistoryController < ApplicationController
  before_action :set_member

  def index
    if @member.nil?
       redirect_to members_path, alert: "Member not found."
      return
    end
    @borrowings = @member.borrowings.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def set_member
    @member = Member.find_by(id: params[:member_id])
  end
end
