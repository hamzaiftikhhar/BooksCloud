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

      book = create(
        :book,
        author: author,
        isbn: "123456789X"
      )

      book.define_singleton_method(:borrow_count) { 5 }

      allow(MostBorrowedBooksQuery)
        .to receive(:call)
        .and_return([book])

      result = presenter.most_borrowed_books

      expect(result.first).to include(
        title: book.title,
        author: "#{author.first_name} #{author.last_name}",
        isbn: book.isbn,
        borrow_count: 5
      )
    end
  end

  describe "#overdue_members" do
    it "returns formatted overdue members" do
      member = create(
        :member,
        name: "Ali",
        email: "ali@test.com",
        membership_number: "M123"
      )

      allow(member) #create mock/stub
       .to receive_message_chain(:overdue_borrowings, :count) #When code runs:  member.overdue_borrowings.count
       .and_return(3)



      allow(OverdueBorrowsQuery)
        .to receive(:call)
        .and_return([member]) #return fake data

        # Because presenter probably fetches data through query object.

        # Without this:

        # presenter uses real DB query
        # your mocked member may never appear

      result = presenter.overdue_members

      expect(result.first).to include(
        name: "Ali",
        email: "ali@test.com",
        membership_number: "M123",
        overdue_count: 3
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