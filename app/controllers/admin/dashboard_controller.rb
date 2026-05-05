module Admin
  class DashboardController < ApplicationController
    before_action :authorize_admin!

    def index
      @users = User.all.order(created_at: :desc)
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: "Admin access required." unless current_user&.admin?
    end
  end
end
