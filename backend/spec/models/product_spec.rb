require "rails_helper"

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }

  it "generates a UUID on create" do
    product = create(:product)
    expect(product.uuid).to be_present
  end

  it "supports soft delete" do
    product = create(:product)
    product.soft_delete!

    expect(product.deleted_at).to be_present
    expect(Product.count).to eq(0)
    expect(Product.with_deleted.count).to eq(1)
  end
end
