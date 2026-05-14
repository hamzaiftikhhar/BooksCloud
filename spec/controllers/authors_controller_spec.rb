require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  describe '#index' do
    it 'returns a successful response' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(assigns(:authors)).to be_a(Author)
    end
  end

  describe '#show' do
    let(:author) { create(:author) }

    it 'returns a successful response' do
      get :show, params: { id: author.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:author)).to eq(author)
      expect(assigns(:books)).to be_a(author.books)
    end
  end

  describe '#new' do
    it 'returns a successful response' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:author)).to be_a(Author)
    end
  end

  describe '#create' do
    let(:author_attributes) { { first_name: 'John', last_name: 'Doe' } }

    context 'with valid attributes' do
      it 'creates a new author' do
        expect {
          post :create, params: { author: author_attributes }
        }.to change(Author, :count).by(1)
        expect(response).to redirect_to(assigns(:author))
        expect(flash[:notice]).to match(/Author created successfully/)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new author' do
        expect {
          post :create, params: { author: { first_name: '', last_name: '' } }
        }.not_to change(Author, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    let(:author) { create(:author) }

    it 'returns a successful response' do
      get :edit, params: { id: author.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:author)).to eq(author)
    end
  end

  describe '#update' do
    let(:author) { create(:author) }

    context 'with valid attributes' do
      it 'updates the author' do
        patch :update, params: { id: author.id, author: { first_name: 'Jane' } }

        expect(author.reload.first_name).to eq('Jane')
        expect(response).to redirect_to(author)
        expect(flash[:notice]).to match(/Author updated successfully/)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the author' do
        patch :update, params: { id: author.id, author: { first_name: '' } }

        expect(author.reload.first_name).to eq('John')
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    let(:author) { create(:author) }

    it 'destroys the author' do
      expect {
        delete :destroy, params: { id: author.id }
      }.to change(Author, :count).by(-1)
      expect(response).to redirect_to(authors_path)
      expect(flash[:notice]).to match(/Author deleted successfully/)
    end
  end
end
