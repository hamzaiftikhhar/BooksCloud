require 'rails_helper'

RSpec.describe "Authors", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /authors" do
    it "returns success" do
      create_list(:author, 2)

      get authors_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Authors")
    end
  end

  describe "GET /authors/:id" do
    let(:author) { create(:author) }
    let!(:book) { create(:book, author: author) }

    it "shows author details" do
      get author_path(author)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(author.first_name)
    end

    it "redirects if not found" do
      get author_path(id: 999999)

      expect(response).to redirect_to(authors_path)
      expect(flash[:alert]).to eq("Author not found.")
    end
  end

  describe "POST /authors" do
    it "creates author" do
      expect {
        post authors_path, params: {
          author: { first_name: "John", last_name: "Doe" }
        }
      }.to change(Author, :count).by(1)
    end

    it "does not create invalid author" do
      expect {
        post authors_path, params: {
          author: { first_name: "", last_name: "" }
        }
      }.not_to change(Author, :count)
    end
  end

  describe "PATCH /authors/:id" do
    let(:author) { create(:author) }

    it "updates author" do
      patch author_path(author), params: {
        author: { first_name: "Jane" }
      }

      expect(author.reload.first_name).to eq("Jane")
    end

    it "does not update with invalid data" do
      patch author_path(author), params: {
        author: { first_name: "" }
      }

      expect(author.reload.first_name).not_to eq("")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /authors/:id" do
    let!(:author) { create(:author) }

    it "deletes author" do
      expect {
        delete author_path(author)
      }.to change(Author, :count).by(-1)
    end
  end
end
