require "rails_helper"

RSpec.describe "Forms GraphQL", type: :request do
  let(:user) { create(:user, :with_all_permissions) }
  let(:user_without_perms) { create(:user) }

  describe "form definitions" do
    let!(:form_def) { create(:form_definition, name: "Contact Form", slug: "contact-form") }

    describe "query formDefinitions" do
      let(:query) { "{ formDefinitions { id name slug status submissionsCount } }" }

      it "lists form definitions for authorized user" do
        graphql_query(query, user: user)

        expect(response).to have_http_status(:ok)
        defs = graphql_data["formDefinitions"]
        expect(defs).to be_present
        expect(defs.first["name"]).to eq("Contact Form")
        expect(defs.first["status"]).to eq("draft")
      end

      it "returns empty list for user without form.view" do
        graphql_query(query, user: user_without_perms)

        expect(response).to have_http_status(:ok)
        expect(graphql_data["formDefinitions"]).to eq([])
      end

      it "denies unauthenticated access" do
        graphql_query(query)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
      end
    end

    describe "query formDefinition" do
      let(:query) do
        <<~GQL
          query FormDefinition($slug: String!) {
            formDefinition(slug: $slug) { id name slug schema status }
          }
        GQL
      end

      it "returns a single form definition by slug" do
        graphql_query(query, variables: { slug: "contact-form" }, user: user)

        expect(response).to have_http_status(:ok)
        data = graphql_data["formDefinition"]
        expect(data["name"]).to eq("Contact Form")
        expect(data["schema"]).to be_a(Hash)
        expect(data["schema"]["fields"]).to be_an(Array)
      end

      it "returns error for nonexistent slug" do
        graphql_query(query, variables: { slug: "nonexistent" }, user: user)

        expect(graphql_errors).to be_present
      end
    end

    describe "mutation createFormDefinition" do
      let(:mutation) do
        <<~GQL
          mutation CreateFormDefinition($name: String!, $slug: String!, $description: String, $schema: JSON) {
            createFormDefinition(name: $name, slug: $slug, description: $description, schema: $schema) {
              ok
              formDefinition { id name slug status schema }
              errors { field messages }
            }
          }
        GQL
      end

      it "creates a form definition in draft status" do
        schema = { "fields" => [{ "name" => "email", "type" => "email", "required" => true }] }
        graphql_query(
          mutation,
          variables: { name: "Signup", slug: "signup", description: "Signup form", schema: schema },
          user: user
        )

        data = graphql_data["createFormDefinition"]
        expect(data["ok"]).to be true
        expect(data["formDefinition"]["name"]).to eq("Signup")
        expect(data["formDefinition"]["status"]).to eq("draft")
        expect(data["formDefinition"]["schema"]["fields"]).to be_present
        expect(FormDefinition.find_by(slug: "signup")).to be_present
      end

      it "creates with default empty schema when none provided" do
        graphql_query(mutation, variables: { name: "Minimal", slug: "minimal" }, user: user)

        data = graphql_data["createFormDefinition"]
        expect(data["ok"]).to be true
        expect(data["formDefinition"]["schema"]["fields"]).to eq([])
      end

      it "returns errors for duplicate slug" do
        graphql_query(mutation, variables: { name: "Dupe", slug: "contact-form" }, user: user)

        data = graphql_data["createFormDefinition"]
        expect(data["ok"]).to be false
        expect(data["errors"]).to be_present
      end

      it "denies creation without form.add permission" do
        graphql_query(mutation, variables: { name: "Nope", slug: "nope" }, user: user_without_perms)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
      end
    end
  end

  describe "form submissions" do
    let!(:form_def) { create(:form_definition, :published, slug: "feedback") }

    describe "mutation createFormSubmission" do
      let(:mutation) do
        <<~GQL
          mutation CreateFormSubmission($formDefinitionSlug: String!, $data: JSON!) {
            createFormSubmission(formDefinitionSlug: $formDefinitionSlug, data: $data) {
              ok
              formSubmission { id status data }
              errors { field messages }
            }
          }
        GQL
      end

      it "creates a submission" do
        submission_data = { "full_name" => "John Doe", "message" => "Hello" }
        graphql_query(
          mutation,
          variables: { formDefinitionSlug: "feedback", data: submission_data },
          user: user
        )

        data = graphql_data["createFormSubmission"]
        expect(data["ok"]).to be true
        expect(data["formSubmission"]["status"]).to eq("submitted")
        expect(data["formSubmission"]["data"]["full_name"]).to eq("John Doe")
        expect(FormSubmission.count).to eq(1)
      end

      it "denies unauthenticated submission" do
        graphql_query(
          mutation,
          variables: { formDefinitionSlug: "feedback", data: { "name" => "Anon" } }
        )

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
      end

      it "returns error for nonexistent form definition" do
        graphql_query(
          mutation,
          variables: { formDefinitionSlug: "nonexistent", data: { "x" => "y" } },
          user: user
        )

        expect(graphql_errors).to be_present
      end
    end

    describe "query formSubmissions" do
      let!(:submission) { create(:form_submission, form_definition: form_def) }

      let(:query) do
        <<~GQL
          query FormSubmissions($formDefinitionSlug: String) {
            formSubmissions(formDefinitionSlug: $formDefinitionSlug) {
              id status data
            }
          }
        GQL
      end

      it "lists submissions for a form definition" do
        graphql_query(query, variables: { formDefinitionSlug: "feedback" }, user: user)

        expect(response).to have_http_status(:ok)
        submissions = graphql_data["formSubmissions"]
        expect(submissions.length).to eq(1)
        expect(submissions.first["status"]).to eq("submitted")
      end

      it "lists all submissions when no filter provided" do
        graphql_query(query, user: user)

        expect(response).to have_http_status(:ok)
        expect(graphql_data["formSubmissions"]).to be_present
      end
    end
  end
end
