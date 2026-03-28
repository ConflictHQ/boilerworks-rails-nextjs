require "rails_helper"

RSpec.describe "Products GraphQL", type: :request do
  let(:user) { create(:user, :with_product_permissions) }
  let!(:product) { create(:product) }

  describe "query products" do
    it "lists products for authorized user" do
      graphql_query("{ products { id name price } }", user: user)

      expect(response).to have_http_status(:ok)
      products = graphql_data["products"]
      expect(products).to be_present
      expect(products.first["name"]).to eq(product.name)
    end

    it "denies unauthenticated access" do
      graphql_query("{ products { id name } }")

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
    end
  end

  describe "mutation createProduct" do
    let(:mutation) do
      <<~GQL
        mutation CreateProduct($name: String!, $price: Float) {
          createProduct(name: $name, price: $price) {
            ok
            product { id name price }
            errors { field messages }
          }
        }
      GQL
    end

    it "creates a product" do
      graphql_query(mutation, variables: { name: "Widget", price: 9.99 }, user: user)

      data = graphql_data["createProduct"]
      expect(data["ok"]).to be true
      expect(data["product"]["name"]).to eq("Widget")
      expect(Product.last.name).to eq("Widget")
    end

    it "returns errors for invalid product" do
      graphql_query(mutation, variables: { name: "", price: 9.99 }, user: user)

      data = graphql_data["createProduct"]
      expect(data["ok"]).to be false
      expect(data["errors"]).to be_present
    end
  end

  describe "mutation deleteProduct" do
    let(:mutation) do
      <<~GQL
        mutation DeleteProduct($id: ID!) {
          deleteProduct(id: $id) { ok }
        }
      GQL
    end

    it "soft deletes a product" do
      graphql_query(mutation, variables: { id: product.uuid }, user: user)

      data = graphql_data["deleteProduct"]
      expect(data["ok"]).to be true
      expect(product.reload.deleted_at).to be_present
    end
  end
end
