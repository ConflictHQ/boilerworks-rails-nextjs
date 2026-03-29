require "rails_helper"

RSpec.describe ItemPolicy do
  let(:user_with_perms) { create(:user, :with_item_permissions) }
  let(:user_without_perms) { create(:user) }
  let(:item) { create(:item) }

  describe "permissions" do
    it "allows viewing for users with item.view" do
      expect(ItemPolicy.new(user_with_perms, item).show?).to be true
    end

    it "denies viewing for users without item.view" do
      expect(ItemPolicy.new(user_without_perms, item).show?).to be false
    end

    it "allows creating for users with item.add" do
      expect(ItemPolicy.new(user_with_perms, Item).create?).to be true
    end

    it "denies creating for users without item.add" do
      expect(ItemPolicy.new(user_without_perms, Item).create?).to be false
    end
  end
end
