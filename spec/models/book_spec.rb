require 'rails_helper'
RSpec.describe Book, type: :model do
  it { should belong_to(:author) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:isbn) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:total_copy_count) }
  it { should validate_presence_of(:available_copy_count) }

  it "is valid with valid attributes" do
    book = build(:book)
    expect(book).to be_valid
  end


  it "is invalid without a title" do
    book = Book.new(title: nil)

    expect(book).not_to be_valid
  end

  describe "#overdue?" do
    it "returns true for past due dates" do
    borrowing = Borrowing.new(due_date: 1.day.ago)

    expect(borrowing.overdue?).to eq(true)
   end
  end
end
