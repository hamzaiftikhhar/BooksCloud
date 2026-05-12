require 'rails_helper'

RSpec.describe "Books API", type: :request do
  include_context "authenticated user"

  describe "GET /books" do
    before do
      create_list(:book, 2)
    end

    it "returns correct number of books" do
      get "/books", headers: { "ACCEPT" => "application/json" }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(2)
    end
  end
end
