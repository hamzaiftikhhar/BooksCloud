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

# if i am not using this dasboard and can access the route:

#   http://127.0.0.1:3000/admin/dashboard
#   then can I remvoe hte
# end
