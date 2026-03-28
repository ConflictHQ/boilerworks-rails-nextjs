require "rails_helper"

RSpec.describe "Categories GraphQL", type: :request do
  let(:user) { create(:user, :with_all_permissions) }
  let(:user_without_perms) { create(:user) }
  let!(:category) { create(:category, name: "Electronics", slug: "electronics") }

  describe "query categories" do
    let(:query) { "{ categories { id name slug description productsCount } }" }

    it "lists categories for authorized user" do
      graphql_query(query, user: user)

      expect(response).to have_http_status(:ok)
      categories = graphql_data["categories"]
      expect(categories).to be_present
      expect(categories.first["name"]).to eq("Electronics")
      expect(categories.first["slug"]).to eq("electronics")
    end

    it "returns empty list for user without category.view" do
      graphql_query(query, user: user_without_perms)

      expect(response).to have_http_status(:ok)
      expect(graphql_data["categories"]).to eq([])
    end

    it "denies unauthenticated access" do
      graphql_query(query)

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
    end
  end

  describe "query category" do
    let(:query) do
      <<~GQL
        query Category($id: ID!) {
          category(id: $id) { id name slug description productsCount }
        }
      GQL
    end

    it "returns a single category by UUID" do
      graphql_query(query, variables: { id: category.uuid }, user: user)

      expect(response).to have_http_status(:ok)
      data = graphql_data["category"]
      expect(data["name"]).to eq("Electronics")
      expect(data["productsCount"]).to eq(0)
    end

    it "denies access for user without category.view" do
      graphql_query(query, variables: { id: category.uuid }, user: user_without_perms)

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
    end

    it "returns error for nonexistent UUID" do
      graphql_query(query, variables: { id: SecureRandom.uuid }, user: user)

      expect(graphql_errors).to be_present
    end
  end

  describe "mutation createCategory" do
    let(:mutation) do
      <<~GQL
        mutation CreateCategory($name: String!, $slug: String!, $description: String) {
          createCategory(name: $name, slug: $slug, description: $description) {
            ok
            category { id name slug description }
            errors { field messages }
          }
        }
      GQL
    end

    it "creates a category" do
      graphql_query(mutation, variables: { name: "Books", slug: "books", description: "All books" }, user: user)

      data = graphql_data["createCategory"]
      expect(data["ok"]).to be true
      expect(data["category"]["name"]).to eq("Books")
      expect(data["category"]["slug"]).to eq("books")
      expect(Category.find_by(slug: "books")).to be_present
    end

    it "returns errors for duplicate slug" do
      graphql_query(mutation, variables: { name: "Dupe", slug: "electronics" }, user: user)

      data = graphql_data["createCategory"]
      expect(data["ok"]).to be false
      expect(data["errors"]).to be_present
    end

    it "returns errors for missing name" do
      graphql_query(mutation, variables: { name: "", slug: "empty" }, user: user)

      data = graphql_data["createCategory"]
      expect(data["ok"]).to be false
      expect(data["errors"]).to be_present
    end

    it "denies creation without category.add permission" do
      graphql_query(mutation, variables: { name: "Nope", slug: "nope" }, user: user_without_perms)

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
    end

    it "denies unauthenticated creation" do
      graphql_query(mutation, variables: { name: "Anon", slug: "anon" })

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
    end
  end

  describe "mutation updateCategory" do
    let(:mutation) do
      <<~GQL
        mutation UpdateCategory($id: ID!, $name: String, $description: String) {
          updateCategory(id: $id, name: $name, description: $description) {
            ok
            category { id name description }
            errors { field messages }
          }
        }
      GQL
    end

    it "updates a category name" do
      graphql_query(mutation, variables: { id: category.uuid, name: "Updated Electronics" }, user: user)

      data = graphql_data["updateCategory"]
      expect(data["ok"]).to be true
      expect(data["category"]["name"]).to eq("Updated Electronics")
      expect(category.reload.name).to eq("Updated Electronics")
    end

    it "updates category description" do
      graphql_query(mutation, variables: { id: category.uuid, description: "New description" }, user: user)

      data = graphql_data["updateCategory"]
      expect(data["ok"]).to be true
      expect(data["category"]["description"]).to eq("New description")
    end

    it "denies update without category.change permission" do
      graphql_query(mutation, variables: { id: category.uuid, name: "Nope" }, user: user_without_perms)

      expect(graphql_errors).to be_present
      expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
    end
  end
end
