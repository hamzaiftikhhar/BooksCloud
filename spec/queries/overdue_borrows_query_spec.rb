require "rails_helper"

RSpec.describe OverdueBorrowsQuery do
  describe ".call" do
    it "returns members with overdue active borrowings" do
      overdue_member = create(:member, name: "Ali")
      normal_member = create(:member, name: "Ahmed")

      overdue_book = create(:book)
      normal_book = create(:book)

      create(
        :borrowing,
        member: overdue_member,
        book: overdue_book,
        status: :active,
        due_date: 5.days.ago
      )

      create(
        :borrowing,
        member: normal_member,
        book: normal_book,
        status: :active,
        due_date: 5.days.from_now
      )

      result = described_class.call # it is calling RSpec.describe OverdueBorrowsQuery do


      expect(result).to include(overdue_member)
      expect(result).not_to include(normal_member)
    end

    it "does not include returned borrowings" do
      member = create(:member)
      book = create(:book)

      create(
        :borrowing,
        member: member,
        book: book,
        status: :returned,
        due_date: 10.days.ago
      )

      result = described_class.call

      expect(result).not_to include(member)
    end

    it "returns distinct members" do
      member = create(:member)
      book1 = create(:book)
      book2 = create(:book)

      create(
        :borrowing,
        member: member,
        book: book1,
        status: :active,
        due_date: 3.days.ago
      )

      create(
        :borrowing,
        member: member,
        book: book2,
        status: :active,
        due_date: 5.days.ago
      )

      result = described_class.call

      expect(result.count).to eq(1)
    end

    it "orders members by name" do
      member_b = create(:member, name: "Zain")
      member_a = create(:member, name: "Ali")

      create(
        :borrowing,
        member: member_b,
        book: create(:book),
        status: :active,
        due_date: 2.days.ago
      )

      create(
        :borrowing,
        member: member_a,
        book: create(:book),
        status: :active,
        due_date: 2.days.ago
      )

      result = described_class.call

      expect(result.first.name).to eq("Ali")
      expect(result.second.name).to eq("Zain")
    end
  end
end
