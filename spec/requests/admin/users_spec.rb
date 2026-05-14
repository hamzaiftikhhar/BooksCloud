require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:user)  { create(:user, role: :librarian) }

  describe "authorization" do
    it "blocks non-admin access" do
      sign_in user

      get admin_users_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /index" do
    it "loads users list for admin" do
      sign_in admin

      get admin_users_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    it "creates a new user" do
      sign_in admin

      expect {
        post admin_users_path, params: {
          user: {
            email: "test@example.com",
            password: "password",
            password_confirmation: "password",
            role: "librarian"
          }
        }
      }.to change(User, :count).by(1)

      expect(response).to be_redirect
    end

    it "fails with invalid params" do
      sign_in admin

      post admin_users_path, params: {
        user: { email: "" }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /destroy" do
    it "deletes user" do
      sign_in admin
      user_to_delete = create(:user)

      expect {
        delete admin_user_path(user_to_delete)
      }.to change(User, :count).by(-1)
    end
  end

  describe "PATCH /change_role" do
    it "updates user role" do
      sign_in admin
      user = create(:user, role: :librarian)

      patch change_role_admin_user_path(user), params: {
        user: { role: "admin" }
      }

      expect(user.reload.role).to eq("admin")
    end
  end
end
