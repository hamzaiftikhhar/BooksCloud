  require "rails_helper"

RSpec.describe MonthlyBorrowingCountQuery do
  describe ".call" do
    it "returns borrowing count grouped by month" do
      january_date = Date.new(2026, 1, 15)
      march_date = Date.new(2026, 3, 10)

      create_list(:borrowing, 2, created_at: january_date)
      create_list(:borrowing, 3, created_at: march_date)

      result = described_class.call(2026)

      expect(result["January"]).to eq(2)
      expect(result["March"]).to eq(3)
      expect(result["February"]).to eq(0)
    end

    it "returns all 12 months" do
      result = described_class.call(2026)

      expect(result.keys.length).to eq(12)
    end

    it "does not include borrowings from another year" do
      create_list(
        :borrowing, 
        5,
        created_at: Date.new(2025, 1, 10)
      )

      result = described_class.call(2026)

      expect(result["January"]).to eq(0)
    end
  end
end