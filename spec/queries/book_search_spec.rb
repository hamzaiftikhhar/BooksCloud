RSpec.describe BookSearch do
  describe ".call" do
    it "returns matching books" do
      book = create(:book, title: "Harry Potter")

      result = BookSearch.call("Harry")

      expect(result).to include(book)
    end
  end
end

