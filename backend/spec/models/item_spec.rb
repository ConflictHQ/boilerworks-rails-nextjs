require "rails_helper"

RSpec.describe Item, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0).allow_nil }

  it "generates a UUID on create" do
    item = create(:item)
    expect(item.uuid).to be_present
  end

  it "supports soft delete" do
    item = create(:item)
    item.soft_delete!

    expect(item.deleted_at).to be_present
    expect(Item.count).to eq(0)
    expect(Item.with_deleted.count).to eq(1)
  end
end
