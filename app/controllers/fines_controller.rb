class FinesController < ApplicationController
  before_action :set_fine, only: %i[show mark_as_paid]

  def index
    @fines = policy_scope(Fine).order(created_at: :desc).page(params[:page]).per(10)
  end

  def outstanding
    @fines = policy_scope(Fine).outstanding.order(created_at: :desc).page(params[:page]).per(10)
    render :index
  end

  def paid
    @fines = policy_scope(Fine).paid.order(created_at: :desc).page(params[:page]).per(10)
    render :index
  end

  def show
  end

  def mark_as_paid
    @fine.mark_as_paid
    redirect_to @fine, notice: "Fine marked as paid."
  rescue StandardError => e
    redirect_to @fine, alert: e.message
  end

  private

  def set_fine
    @fine = Fine.find_by(id: params[:id])
  end
end
