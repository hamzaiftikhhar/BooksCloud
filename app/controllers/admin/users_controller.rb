module Admin
  class UsersController < ApplicationController
    before_action :authorize_admin!
    before_action :set_user, only: %i[show destroy change_role]

    def index
      @users = User.all.order(created_at: :desc).page(params[:page]).per(10)
    end

    def show
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: "Staff account created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "Staff account deleted successfully."
    end

    def change_role
      @user.update!(role: params.require(:user).permit(:role)[:role])
      redirect_to admin_user_path(@user), notice: "Staff role updated successfully."
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: "Admin access required." unless current_user&.admin?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end
  end
end
