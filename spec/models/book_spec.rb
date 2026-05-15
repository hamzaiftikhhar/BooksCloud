require 'rails_helper'

RSpec.describe Book, type: :model do
  # ASSOCIATIONS

  it { should belong_to(:author) }
  it { should have_many(:borrowings).dependent(:destroy) }
  it { should have_many(:members).through(:borrowings) }
  it { should have_many(:fines).through(:borrowings) }


  # VALIDATIONS (BASIC)

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:isbn) }
  it { should validate_presence_of(:publication_date) }
  it { should validate_presence_of(:total_copy_count) }
  it { should validate_presence_of(:available_copy_count) }
  it { should validate_presence_of(:genre) }


  # POSITIVE CASE

  it "is valid with all correct attributes" do
    book = build(:book)
    expect(book).to be_valid
  end


  # TITLE VALIDATIONS

  it "is invalid when title is empty string" do
    book = build(:book, title: "")
    expect(book).not_to be_valid
  end

  it "is invalid when title exceeds 255 characters" do
    book = build(:book, title: "a" * 256)
    expect(book).not_to be_valid
  end


  # ISBN VALIDATIONS

  it "is invalid with wrong ISBN format" do
    book = build(:book, isbn: "123ABC")
    expect(book).not_to be_valid
  end

  it "is valid with ISBN-10 format" do
    book = build(:book, isbn: "123456789X")
    expect(book).to be_valid
  end

  it "is valid with ISBN-13 format" do
    book = build(:book, isbn: "9781234567897")
    expect(book).to be_valid
  end

  it "is invalid with duplicate ISBN" do
    create(:book, isbn: "123456789X")
    book = build(:book, isbn: "123456789X")

    expect(book).not_to be_valid
  end

  it "shows correct ISBN error message" do
    book = build(:book, isbn: "invalid")

    book.valid?

    expect(book.errors[:isbn]).to include(
      "must be a valid ISBN format (ISBN-10 or ISBN-13)"
    )
  end


  # DESCRIPTION VALIDATION

  it "is invalid when description is nil" do
    book = build(:book, description: nil)
    expect(book).not_to be_valid
  end

  it "is invalid when description is empty string" do
    book = build(:book, description: "")
    expect(book).not_to be_valid
  end


  # PUBLICATION DATE

  it "is invalid when publication date is in the future" do
    book = build(:book, publication_date: 1.day.from_now)
    expect(book).not_to be_valid
  end


  # COPY COUNT VALIDATIONS

  it "is invalid when total_copy_count is zero" do
    book = build(:book, total_copy_count: 0)
    expect(book).not_to be_valid
  end

  it "is invalid when available_copy_count is negative" do
    book = build(:book, available_copy_count: -1)
    expect(book).not_to be_valid
  end

  it "is invalid when available_copy_count exceeds total_copy_count" do
    book = build(:book,
      total_copy_count: 5,
      available_copy_count: 10
    )

    expect(book).not_to be_valid
  end

  it "is valid when available_copy_count equals total_copy_count" do
    book = build(:book,
      total_copy_count: 5,
      available_copy_count: 5
    )

    expect(book).to be_valid
  end

  it "is valid when available_copy_count is zero" do
    book = build(:book, available_copy_count: 0)
    expect(book).to be_valid
  end


  # ENUM TESTS

  it "supports genre enum values" do
    book = build(:book, genre: :fiction)
    expect(book.fiction?).to be true
  end

  it "correctly stores genre value" do
    book = build(:book, genre: :thriller)
    expect(book.genre).to eq("thriller")
  end


  # INSTANCE METHODS

  describe "#copy_available?" do
    it "returns true when copies are available" do
      book = build(:book, available_copy_count: 3)
      expect(book.copy_available?).to be true
    end

    it "returns false when no copies available" do
      book = build(:book, available_copy_count: 0)
      expect(book.copy_available?).to be false
    end
  end

  describe "#increase_available_copy_count" do
    it "increases available copies" do
      book = create(:book, available_copy_count: 2)

      book.increase_available_copy_count(1)

      expect(book.reload.available_copy_count).to eq(3)
    end
  end

  describe "#decrease_available_copy_count" do
    it "decreases available copies" do
      book = create(:book, available_copy_count: 5)

      book.decrease_available_copy_count(1)

      expect(book.reload.available_copy_count).to eq(4)
    end
  end

  # ATTACHMENTS
  it "can attach a cover image" do
    book = create(:book)

    book.cover.attach(
      io: StringIO.new("fake image content"),
      filename: "cover.jpg",
      content_type: "image/jpeg"
    )

    expect(book.cover).to be_attached
  end

  it "rejects invalid file types" do
    book = build(:book)

    book.cover.attach(
      io: StringIO.new("pdf"), # StringIO.new: returns a new StringIO object containing the given string.
      filename: "file.pdf",
      content_type: "application/pdf"
    )

    expect(book).not_to be_valid
    expect(book.errors[:cover]).to include("must be JPG, PNG, or WEBP")
  end
end
