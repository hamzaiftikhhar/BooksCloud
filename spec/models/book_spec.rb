require 'rails_helper'
RSpec.describe Book, type: :model do
  it { should belong_to(:author) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:isbn) }
  it { should validate_presence_of(:description) }

  it "is valid with valid attributes" do
    author = Author.create!(first_name: "J.K", last_name: "Rowling")

    book = Book.new(
      title: "Atomic Habits",
      author_id: author.id,
      isbn: "9783161484100",
      description: "Good book",
      publication_date: Date.current,
      total_copy_count: 10,
      available_copy_count: 10,
      genre: 3
    )

    expect(book).to be_valid
  end


  it "is invalid without a title" do
    book = Book.new(title: nil)

    expect(book).not_to be_valid
  end
end
