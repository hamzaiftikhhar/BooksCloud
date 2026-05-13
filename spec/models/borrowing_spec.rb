require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  # ASSOCIATIONS

  it { should belong_to(:member) }
  it { should belong_to(:book) }
  it { should have_many(:fines).dependent(:destroy) }


  # VALIDATIONS

  it { should validate_presence_of(:member_id) }
  it { should validate_presence_of(:book_id) }
  it { should validate_presence_of(:status) }


  # ENUM

  it "has correct status enum" do
    borrowing = build(:borrowing, status: :active)

    expect(borrowing.active?).to be true
    expect(borrowing.returned?).to be false
  end


  # SCOPES

  describe "scopes" do
    it "returns only active borrowings" do
      active = create(:borrowing, status: :active)
      returned = create(:borrowing, status: :returned)

      expect(Borrowing.active).to include(active)
      expect(Borrowing.active).not_to include(returned)
    end

    it "returns only returned borrowings" do
      returned = create(:borrowing, status: :returned)

      expect(Borrowing.returned).to include(returned)
    end

    it "returns overdue borrowings" do
      overdue = create(:borrowing,
        status: :active,
        due_date: 2.days.ago
      )

      expect(Borrowing.overdue).to include(overdue)
    end
  end


  # CALLBACKS

  describe "callbacks" do
    it "sets issue_date automatically on create" do
      borrowing = create(:borrowing)

      expect(borrowing.issue_date).to be_present
    end

    it "sets due_date automatically if not provided" do
      borrowing = create(:borrowing, due_date: nil)

      expect(borrowing.due_date).to be_present
    end
  end


  # INSTANCE METHODS


  describe "#overdue?" do
    it "returns true when due date is passed and not returned" do
      borrowing = build(:borrowing, due_date: 3.days.ago, return_date: nil)

      expect(borrowing.overdue?).to be true
    end

    it "returns false when returned before due date" do
      borrowing = build(:borrowing,
        due_date: 3.days.ago,
        return_date: 4.days.ago
      )

      expect(borrowing.overdue?).to be false
    end
  end

  describe "#days_overdue" do
    it "returns correct overdue days" do
      borrowing = build(:borrowing, due_date: 3.days.ago)

      # binding.pry

      expect(borrowing.days_overdue).to eq(3)
    end

    it "returns 0 when not overdue" do
      borrowing = build(:borrowing, due_date: 3.days.from_now)

      expect(borrowing.days_overdue).to eq(0)
    end
  end

  describe "#mark_as_returned" do
    it "updates status and return_date" do
      borrowing = create(:borrowing, status: :active)

      borrowing.mark_as_returned(Time.current)

      expect(borrowing.returned?).to be true
      expect(borrowing.return_date).to be_present
    end
  end

  describe "#borrowing_history" do
    it "returns structured hash of borrowing details" do
      borrowing = create(:borrowing)

      result = borrowing.borrowing_history

      expect(result).to include(
        :member,
        :book,
        :issue_date,
        :due_date,
        :status,
        :overdue
      )
    end
  end


  # EDGE CASES

  it "handles nil due_date safely in overdue?" do
    borrowing = build(:borrowing, due_date: nil)

    expect(borrowing.overdue?).to be false
  end
end
