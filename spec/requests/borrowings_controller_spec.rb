require 'rails_helper'

RSpec.describe "Borrowings", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /borrowings" do
    it "returns success" do
      create_list(:borrowing, 2)

      get borrowings_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /borrowings/:id" do
    let(:borrowing) { create(:borrowing) }

    it "returns success" do
      get borrowing_path(borrowing)

      expect(response).to have_http_status(:ok)
    end
  end

  # describe "POST /borrowings" do
  #   let(:member) { create(:member) }
  #   let(:book) { create(:book, available_copy_count: 5) }

  #   it "creates borrowing successfully" do
  #     expect {
  #       post borrowings_path, params: {
  #         book_id: book.id,
  #         borrowing: {
  #           membership_number: member.membership_number
  #         }
  #       }
  #     }.to change(Borrowing, :count).by(1)

  #     expect(response).to redirect_to(borrowings_path)
  #     expect(flash[:notice]).to eq("Book has been issued.")
  #   end

  #   it "fails when member not found" do
  #     post borrowings_path, params: {
  #       book_id: book.id,
  #       borrowing: {
  #         membership_number: "INVALID"
  #       }
  #     }

  #     expect(response).to redirect_to(borrowings_path)
  #     expect(flash[:alert]).to eq("Member not found")
  #   end
  # end


  describe "POST /borrowings" do
    let(:member) { create(:member, status: :active) }

    let(:book) do
      create(
        :book,
        available_copy_count: 5,
        total_copy_count: 5
      )
    end

    it "creates borrowing successfully" do
      expect {
        post borrowings_path, params: {
          book_id: book.id,
          borrowing: {
            membership_number: member.membership_number,
            issue_date: Date.current,
            due_date: Date.current + LibraryConstants::LOAN_PERIOD_DAYS.days
          }
        }
      }.to change(Borrowing, :count).by(1)
      expect(response).to redirect_to(borrowings_path)

      expect(flash[:notice]).to eq("Book has been issued.")
    end
  end

  describe "GET /borrowings/search_member" do
    let(:member) { create(:member) }
    let(:book) { create(:book) }

    it "returns success" do
      get search_member_borrowings_path, params: {
        membership_number: member.membership_number,
        book_id: book.id
      }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /borrowings/:id/return_book" do
    let(:borrowing) { create(:borrowing, status: :active) }

    it "returns book successfully" do
      patch return_book_borrowing_path(borrowing)

      expect(response).to redirect_to(borrowing_path(borrowing))

      follow_redirect!

      expect(response).to have_http_status(:ok)
    end
  end
end
