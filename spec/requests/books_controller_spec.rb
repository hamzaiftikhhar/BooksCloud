require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe '#index' do
    it 'returns success' do
      create_list(:book, 2)

      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:book) { create(:book) }

    it 'returns success' do
      get :show, params: { id: book.id }

      expect(response).to have_http_status(:ok)
    end

    it 'redirects when book not found' do
      get :show, params: { id: 999999 }

      expect(response).to redirect_to(books_path)
      expect(flash[:alert]).to eq("Book not found.")
    end
  end

  describe '#create' do
    let(:author) { create(:author) }

    it 'creates book' do
      expect {
        post :create, params: {
            book: {
            title: "Book Title",
            author_id: author.id,
            isbn: "123456789X",
            publication_date: Date.yesterday,
            total_copy_count: 5,
            available_copy_count: 5,
            genre: :fiction,
            description: "A valid description"
          }

        }
      }.to change(Book, :count).by(1)
    end

    it 'does not create invalid book' do
      expect {
        post :create, params: {
          book: { title: "", author_id: "" }
        }
      }.not_to change(Book, :count)
    end
  end

  describe '#update' do
    let(:book) { create(:book) }

    it 'updates book' do
      patch :update, params: {
        id: book.id,
        book: { title: "New Title" }
      }

      expect(book.reload.title).to eq("New Title")
      expect(response).to redirect_to(book)
    end
  end

  describe '#destroy' do
  let(:user) { create(:user, role: :admin) }

    before { sign_in user }

    it 'destroys book' do
      book = create(:book)

      expect {
        delete :destroy, params: { id: book.id }
      }.to change(Book, :count).by(-1)
    end
  end
end
