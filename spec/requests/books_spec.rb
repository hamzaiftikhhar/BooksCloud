require 'rails_helper'

RSpec.describe "Books API", type: :request do
  describe "GET /books" do
    context "when user is authenticated" do
      let(:user) { create(:user) }

      before do
        sign_in user
        create_list(:book, 2)
      end

      it "returns correct number of books" do
        get "/books", headers: { "ACCEPT" => "application/json" }

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json.length).to eq(2)
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized" do
        get "/books", headers: { "ACCEPT" => "application/json" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
