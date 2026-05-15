require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /" do
    it "returns success" do
      get root_path

      expect(response).to have_http_status(:ok)
    end

    it "loads dashboard statistics" do
      create_list(:book, 2)
      create_list(:member, 2)

      get root_path

      expect(response.body).to be_present
    end
  end
end
