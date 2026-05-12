require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    it "returns success" do
      get books_path

      expect(response).to have_http_status(:success)
    end
  end
end
