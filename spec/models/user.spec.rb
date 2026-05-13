require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:role) }
  end

  describe "enums" do
    it do
      should define_enum_for(:role)
        .with_values(librarian: 0, admin: 1)
    end
  end

  describe "devise modules" do
    it "authenticates with password" do
      user = create(:user, password: "password123")

      expect(user.valid_password?("password123")).to be true
      expect(user.valid_password?("wrongpass")).to be false
    end

    it "requires email and password for creation" do
      user = User.new(email: nil, password: nil)

      expect(user.valid?).to be false
      expect(user.errors[:email]).to be_present
    end
  end

  describe "roles" do
    let(:admin) { create(:user, role: :admin) }
    let(:librarian) { create(:user, role: :librarian) }

    it "sets admin role correctly" do
      expect(admin.admin?).to be true
      expect(admin.librarian?).to be false
    end

    it "sets librarian role correctly" do
      expect(librarian.librarian?).to be true
      expect(librarian.admin?).to be false
    end
  end
end
