require 'rails_helper'

RSpec.describe "Fines", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /fines" do
    it "returns success" do
      create_list(:fine, 2)

      get fines_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /fines/outstanding" do
    it "returns success" do
      create(:fine, status: :outstanding)

      get outstanding_fines_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /fines/paid" do
    it "returns success" do
      create(:fine, status: :paid)

      get paid_fines_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /fines/:id" do
    let(:fine) { create(:fine) }

    it "returns success" do
      get fine_path(fine)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /fines/:id/mark_as_paid" do
    let(:fine) { create(:fine, status: :outstanding) }

    it "marks fine as paid" do
      post mark_as_paid_fine_path(fine)

      expect(response).to redirect_to(fine_path(fine))
      expect(flash[:notice]).to eq("Fine marked as paid.")

      expect(fine.reload.status).to eq("paid")
    end
  end
end
