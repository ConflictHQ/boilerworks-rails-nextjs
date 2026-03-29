require "rails_helper"

RSpec.describe "Items GraphQL", type: :request do
  let(:user) { create(:user, :with_item_permissions) }
  let!(:item) { create(:item) }

  describe "query items" do
    it "lists items for authorized user" do
      graphql_query("{ items { id name price } }", user: user)

      expect(response).to have_http_status(:ok)
      items = graphql_data["items"]
      expect(items).to be_present
      expect(items.first["name"]).to eq(item.name)
    end

    it "denies unauthenticated access" do
      graphql_query("{ items { id name } }")

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
    end
  end

  describe "mutation createItem" do
    let(:mutation) do
      <<~GQL
        mutation CreateItem($name: String!, $price: Float) {
          createItem(name: $name, price: $price) {
            ok
            item { id name price }
            errors { field messages }
          }
        }
      GQL
    end

    it "creates a item" do
      graphql_query(mutation, variables: { name: "Widget", price: 9.99 }, user: user)

      data = graphql_data["createItem"]
      expect(data["ok"]).to be true
      expect(data["item"]["name"]).to eq("Widget")
      expect(Item.last.name).to eq("Widget")
    end

    it "returns errors for invalid item" do
      graphql_query(mutation, variables: { name: "", price: 9.99 }, user: user)

      data = graphql_data["createItem"]
      expect(data["ok"]).to be false
      expect(data["errors"]).to be_present
    end
  end

  describe "mutation deleteItem" do
    let(:mutation) do
      <<~GQL
        mutation DeleteItem($id: ID!) {
          deleteItem(id: $id) { ok }
        }
      GQL
    end

    it "soft deletes a item" do
      graphql_query(mutation, variables: { id: item.uuid }, user: user)

      data = graphql_data["deleteItem"]
      expect(data["ok"]).to be true
      expect(item.reload.deleted_at).to be_present
    end
  end
end
