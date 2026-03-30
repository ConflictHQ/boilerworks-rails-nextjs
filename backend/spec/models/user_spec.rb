require "rails_helper"

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { should validate_presence_of(:email_address) }
  it { should validate_uniqueness_of(:email_address).case_insensitive }
  it { should have_many(:sessions).dependent(:destroy) }

  it "normalizes email to lowercase" do
    user = create(:user, email_address: "TEST@Example.COM")
    expect(user.email_address).to eq("test@example.com")
  end

  describe "#has_permission?" do
    it "returns true when user has the permission" do
      user = create(:user, :with_item_permissions)
      expect(user.has_permission?("item.view")).to be true
    end

    it "returns false when user lacks the permission" do
      user = create(:user)
      expect(user.has_permission?("item.view")).to be false
    end
  end
end
