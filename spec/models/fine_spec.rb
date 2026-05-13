require 'rails_helper'

RSpec.describe Fine, type: :model do
  describe "associations" do
    it { should belong_to(:borrowing) }
  end

  describe "delegations" do
    it "delegates member to borrowing" do
      borrowing = create(:borrowing)
      fine = create(:fine, borrowing: borrowing)

      expect(fine.member).to eq(borrowing.member)
    end

    it "delegates book to borrowing" do
      borrowing = create(:borrowing)
      fine = create(:fine, borrowing: borrowing)

      expect(fine.book).to eq(borrowing.book)
    end
  end

  describe "validations" do
    subject { build(:fine) }

    it { should validate_presence_of(:borrowing_id) }
    it { should validate_presence_of(:amount_due) }
    it { should validate_presence_of(:status) }

    it { should validate_numericality_of(:amount_due).is_greater_than(0) }

    it do
      should validate_numericality_of(:amount_paid)
        .is_greater_than_or_equal_to(0)
        .allow_nil
    end
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(outstanding: "outstanding", paid: "paid")
    end
  end

  describe "scopes" do
    let!(:outstanding_fine) { create(:fine, status: :outstanding) }
    let!(:paid_fine) { create(:fine, status: :paid) }

    describe ".outstanding" do
      it "returns outstanding fines" do
        expect(Fine.outstanding).to include(outstanding_fine)
        expect(Fine.outstanding).not_to include(paid_fine)
      end
    end

    describe ".paid" do
      it "returns paid fines" do
        expect(Fine.paid).to include(paid_fine)
        expect(Fine.paid).not_to include(outstanding_fine)
      end
    end
  end

  describe "#mark_as_paid" do
    it "marks fine as paid with full amount" do
      fine = create(:fine, amount_due: 100, status: :outstanding)

      fine.mark_as_paid

      expect(fine.status).to eq("paid")
      expect(fine.amount_paid).to eq(100)
    end

    it "allows partial payment" do
      fine = create(:fine, amount_due: 100, status: :outstanding)

      fine.mark_as_paid(60)

      expect(fine.amount_paid).to eq(60)
      expect(fine.status).to eq("paid")
    end

    it "raises error if already paid" do
      fine = create(:fine, status: :paid, amount_due: 100, amount_paid: 100)

      expect {
        fine.mark_as_paid
      }.to raise_error("Fine is already paid")
    end
  end

  describe "#outstanding_amount" do
    it "calculates remaining amount correctly" do
      fine = build(:fine, amount_due: 100, amount_paid: 40)

      expect(fine.outstanding_amount).to eq(60)
    end

    it "returns full amount if nothing paid" do
      fine = build(:fine, amount_due: 100, amount_paid: nil)

      expect(fine.outstanding_amount).to eq(100)
    end
  end

  describe "#fully_paid?" do
    it "returns true when fully paid" do
      fine = build(:fine, amount_due: 100, amount_paid: 100, status: :paid)

      expect(fine.fully_paid?).to be true
    end

    it "returns false when not paid fully" do
      fine = build(:fine, amount_due: 100, amount_paid: 50, status: :paid)

      expect(fine.fully_paid?).to be false
    end

    it "returns false when not marked paid" do
      fine = build(:fine, amount_due: 100, amount_paid: 100, status: :outstanding)

      expect(fine.fully_paid?).to be false
    end
  end
end
