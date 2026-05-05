class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy suspend reactivate]

  def index
    @members = policy_scope(Member).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member, notice: "Member created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to @member, notice: "Member updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin?
      @member.destroy
      redirect_to members_path, notice: "Member deleted successfully."
    else
      redirect_to @member, alert: "Only admins can delete members."
    end
  end

  def suspend
    authorize @member, :suspend?
    @member.update!(status: :suspended)
    redirect_to @member, notice: "Member suspended."
  end

  def reactivate
    authorize @member, :suspend?
    @member.update!(status: :active)
    redirect_to @member, notice: "Member reactivated."
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(
      :name,
      :email,
      :phone,
      :status,
      :max_books_allowed
    )
  end
end
