require 'rails_helper'

RSpec.describe ReportPresenter do
  let(:presenter) { described_class.new }

  describe "#financial_summary" do
    before do
      create(:fine, status: :outstanding, amount_due: 100)
      create(:fine, status: :paid, amount_paid: 50)
    end

    it "returns correct financial summary" do
      result = presenter.financial_summary

      expect(result[:outstanding_fines]).to eq(100)
      expect(result[:paid_fines]).to eq(50)
      expect(result[:total_fines]).to eq(150)
    end
  end

  describe "#most_borrowed_books" do
    it "returns formatted most borrowed books" do
      author = create(:author, first_name: "John", last_name: "Doe")
      book = create(:book, author: author, isbn: "123456789X")

      # assuming borrow_count comes from query or method
      allow(book).to receive(:borrow_count).and_return(5)

      result = presenter.most_borrowed_books

      expect(result.first).to include(
        :title,
        :author,
        :isbn,
        :borrow_count
      )
    end
  end

  describe "#overdue_members" do
    it "returns formatted overdue members" do
      member = create(:member,
        name: "Ali",
        email: "ali@test.com",
        membership_number: "M123"
      )

      allow(member).to receive_message_chain(:overdue_borrowings, :count).and_return(3)

      result = presenter.overdue_members

      expect(result.first).to include(
        :name,
        :email,
        :membership_number,
        :overdue_count
      )
    end
  end

  describe "#monthly_borrowing_data" do
    it "returns monthly borrowing data from query" do
      result = presenter.monthly_borrowing_data

      expect(result).to be_present
    end
  end
end