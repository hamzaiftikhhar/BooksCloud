require 'rails_helper'

RSpec.describe Author, type: :model do
  describe "associations" do
    it { should have_many(:books) }
  end

  describe "validations" do
    subject { create(:author) }

    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_least(1).is_at_most(255) }

    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_least(1).is_at_most(255) }

    it "validates uniqueness of first_name scoped to last_name" do
      create(:author, first_name: "John", last_name: "Doe")

      duplicate = build(:author, first_name: "John", last_name: "Doe")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:first_name]).to include(
        "and last name combination already exists"
      )
    end
  end

  describe "#name" do
    it "returns full name by combining first and last name" do
      author = build(:author, first_name: "John", last_name: "Doe")

      expect(author.name).to eq("John Doe")
    end

    it "handles normal formatting without extra spaces" do
      author = build(:author, first_name: "Jane", last_name: "Smith")

      expect(author.name).to eq("Jane Smith")
    end
  end
end
