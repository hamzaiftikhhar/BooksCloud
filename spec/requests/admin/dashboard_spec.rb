require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:user)  { create(:user, role: :librarian) }

  describe "GET /admin/dashboard" do
    context "when admin" do
      it "allows access" do
        sign_in admin

        get admin_root_path

        expect(response).to have_http_status(:ok)

        # Instead of assigns, verify behavior indirectly

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(admin.email)
      end
    end

    context "when not admin" do
      it "redirects to root path" do
        sign_in user

        get admin_root_path

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Admin access required.")
      end
    end
  end
end
