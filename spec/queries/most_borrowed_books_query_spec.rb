require "rails_helper"

RSpec.describe MostBorrowedBooksQuery do
  describe ".call" do
    it "returns books ordered by borrow count descending" do
      author = create(:author)

      popular_book = create(:book, author: author)
      normal_book = create(:book, author: author)

      create_list(:borrowing, 5, book: popular_book)
      create_list(:borrowing, 2, book: normal_book)

      result = described_class.call

      expect(result.first).to eq(popular_book)
      expect(result.second).to eq(normal_book)
    end

    it "adds borrow_count attribute" do
      author = create(:author)

      book = create(:book, author: author)

      create_list(:borrowing, 3, book: book)

      result = described_class.call

      expect(result.first.borrow_count.to_i).to eq(3)
    end

    it "respects limit parameter" do
      author = create(:author)

      create_list(:book, 15, author: author).each_with_index do |book, index|
        create_list(:borrowing, index + 1, book: book)
      end

      result = described_class.call(5)

      expect(result.length).to eq(5)
    end

    it "does not include books with no borrowings" do
      author = create(:author)

      borrowed_book = create(:book, author: author)
      unborrowed_book = create(:book, author: author)

      create_list(:borrowing, 2, book: borrowed_book)

      result = described_class.call

      expect(result).to include(borrowed_book)
      expect(result).not_to include(unborrowed_book)
    end
  end
end