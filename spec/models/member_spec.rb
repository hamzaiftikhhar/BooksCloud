# spec/models/member_spec.rb

require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "associations" do
    it { should have_many(:borrowings).dependent(:destroy) }
    it { should have_many(:books).through(:borrowings) }
    it { should have_many(:fines).through(:borrowings) }
  end

  describe "validations" do
    subject { create(:member) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(1).is_at_most(255) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:phone) }
    it { should validate_length_of(:phone).is_at_least(10).is_at_most(20) }

    it { should validate_presence_of(:membership_number) }
    it { should validate_uniqueness_of(:membership_number) }

    it { should validate_presence_of(:max_books_allowed) }

    it do
      should validate_numericality_of(:max_books_allowed)
        .only_integer
        .is_greater_than(0)
    end

    it { should validate_presence_of(:status) }
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(active: 0, suspended: 1, expired: 2)
    end
  end

  describe "scopes" do
    let!(:active_member) { create(:member, status: :active) }
    let!(:suspended_member) { create(:member, status: :suspended) }
    let!(:expired_member) { create(:member, status: :expired) }

    describe ".active" do
      it "returns active members" do
        expect(Member.active).to include(active_member)
        expect(Member.active).not_to include(suspended_member, expired_member)
      end
    end

    describe ".suspended" do
      it "returns suspended members" do
        expect(Member.suspended).to include(suspended_member)
        expect(Member.suspended).not_to include(active_member, expired_member)
      end
    end

    describe ".expired" do
      it "returns expired members" do
        expect(Member.expired).to include(expired_member)
        expect(Member.expired).not_to include(active_member, suspended_member)
      end
    end
  end

  describe "callbacks" do
    describe "#generate_membership_number" do
      it "generates membership number on create" do
        member = create(:member, membership_number: nil)

        expect(member.membership_number).to be_present
        expect(member.membership_number).to start_with("MEM")
      end
    end

    describe "#set_default_borrow_limit" do
      it "sets default borrow limit" do
        member = create(:member, max_books_allowed: nil)

        expect(member.max_books_allowed)
          .to eq(LibraryConstants::DEFAULT_BORROW_LIMIT)
      end
    end

    describe "#set_default_status" do
      it "sets default status to active" do
        member = create(:member, status: nil)

        expect(member.status).to eq("active")
      end
    end
  end

  describe "#active_borrowings" do
    it "returns only active borrowings" do
      member = create(:member)

      active_borrowing =
        create(:borrowing, member: member, status: :active)

      returned_borrowing =
        create(:borrowing, member: member, status: :returned)

      expect(member.active_borrowings)
        .to include(active_borrowing)

      expect(member.active_borrowings)
        .not_to include(returned_borrowing)
    end
  end

  describe "#borrow_limit" do
    it "returns max books allowed" do
      member = create(:member, max_books_allowed: 5)

      expect(member.borrow_limit).to eq(5)
    end
  end

  describe "#overdue_borrowings" do
    it "returns overdue borrowings" do
      member = create(:member)

      overdue_borrowing = create(
        :borrowing,
        member: member,
        due_date: 3.days.ago,
        return_date: nil,
        status: :active
      )

      non_overdue_borrowing = create(
        :borrowing,
        member: member,
        due_date: 3.days.from_now,
        return_date: nil,
        status: :active
      )

      expect(member.overdue_borrowings)
        .to include(overdue_borrowing)

      expect(member.overdue_borrowings)
        .not_to include(non_overdue_borrowing)
    end
  end

  describe "#can_borrow?" do
    context "when member is active and under limit" do
      it "returns true" do
        member = create(:member, max_books_allowed: 3)

        create_list(:borrowing, 2,
          member: member,
          status: :active
        )

        expect(member.can_borrow?).to be true
      end
    end

    context "when member reached borrow limit" do
      it "returns false" do
        member = create(:member, max_books_allowed: 2)

        create_list(:borrowing, 2,
          member: member,
          status: :active
        )

        expect(member.can_borrow?).to be false
      end
    end

    context "when member is suspended" do
      it "returns false" do
        member = create(:member, status: :suspended)

        expect(member.can_borrow?).to be false
      end
    end

    context "when member is expired" do
      it "returns false" do
        member = create(:member, status: :expired)

        expect(member.can_borrow?).to be false
      end
    end
  end
end
