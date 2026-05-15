require 'rails_helper'

RSpec.describe "BorrowingHistory", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /members/:member_id/borrowing_history" do
    let(:member) { create(:member) }

    it "returns success" do
      create_list(:borrowing, 2, member: member)

      get member_borrowing_history_index_path(member)

      expect(response).to have_http_status(:ok)
    end

    it "redirects when member not found" do
      get member_borrowing_history_index_path(member_id: 999999)

      expect(response).to redirect_to(members_path)
      expect(flash[:alert]).to eq("Member not found.")
    end
  end
end
