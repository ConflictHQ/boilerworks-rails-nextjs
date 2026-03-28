require "rails_helper"

RSpec.describe ProductPolicy do
  let(:user_with_perms) { create(:user, :with_product_permissions) }
  let(:user_without_perms) { create(:user) }
  let(:product) { create(:product) }

  describe "permissions" do
    it "allows viewing for users with product.view" do
      expect(ProductPolicy.new(user_with_perms, product).show?).to be true
    end

    it "denies viewing for users without product.view" do
      expect(ProductPolicy.new(user_without_perms, product).show?).to be false
    end

    it "allows creating for users with product.add" do
      expect(ProductPolicy.new(user_with_perms, Product).create?).to be true
    end

    it "denies creating for users without product.add" do
      expect(ProductPolicy.new(user_without_perms, Product).create?).to be false
    end
  end
end
