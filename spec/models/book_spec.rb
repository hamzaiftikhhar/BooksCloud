require 'rails_helper'
RSpec.describe Book, type: :model do
  it { should belong_to(:author) }

  it "is valid with a title" do
    book = Book.new(title: "Atomic Habits")

    expect(book).to be_valid
  end

  it "is invalid without a title" do
    book = Book.new(title: nil)

    expect(book).not_to be_valid
  end
end
