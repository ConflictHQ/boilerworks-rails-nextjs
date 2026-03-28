require "rails_helper"

RSpec.describe "Workflows GraphQL", type: :request do
  let(:user) { create(:user, :with_all_permissions) }
  let(:user_without_perms) { create(:user) }

  let!(:workflow_def) do
    create(:workflow_definition,
      name: "Approval Flow",
      slug: "approval-flow",
      states: [
        { "name" => "draft", "initial" => true },
        { "name" => "review" },
        { "name" => "approved" },
        { "name" => "rejected" }
      ],
      transitions: [
        { "from" => "draft", "to" => "review" },
        { "from" => "review", "to" => "approved" },
        { "from" => "review", "to" => "rejected" }
      ]
    )
  end

  describe "workflow definitions" do
    describe "query workflowDefinitions" do
      let(:query) { "{ workflowDefinitions { id name slug states transitions instancesCount } }" }

      it "lists workflow definitions for authorized user" do
        graphql_query(query, user: user)

        expect(response).to have_http_status(:ok)
        defs = graphql_data["workflowDefinitions"]
        expect(defs).to be_present
        expect(defs.first["name"]).to eq("Approval Flow")
        expect(defs.first["states"]).to be_an(Array)
        expect(defs.first["transitions"]).to be_an(Array)
        expect(defs.first["instancesCount"]).to eq(0)
      end

      it "returns empty list for user without workflow.view" do
        graphql_query(query, user: user_without_perms)

        expect(response).to have_http_status(:ok)
        expect(graphql_data["workflowDefinitions"]).to eq([])
      end

      it "denies unauthenticated access" do
        graphql_query(query)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
      end
    end

    describe "query workflowDefinition" do
      let(:query) do
        <<~GQL
          query WorkflowDefinition($slug: String!) {
            workflowDefinition(slug: $slug) { id name slug states transitions }
          }
        GQL
      end

      it "returns a single workflow definition by slug" do
        graphql_query(query, variables: { slug: "approval-flow" }, user: user)

        expect(response).to have_http_status(:ok)
        data = graphql_data["workflowDefinition"]
        expect(data["name"]).to eq("Approval Flow")
        expect(data["states"].length).to eq(4)
        expect(data["transitions"].length).to eq(3)
      end

      it "returns error for nonexistent slug" do
        graphql_query(query, variables: { slug: "nonexistent" }, user: user)

        expect(graphql_errors).to be_present
      end
    end

    describe "mutation createWorkflowDefinition" do
      let(:mutation) do
        <<~GQL
          mutation CreateWorkflowDefinition(
            $name: String!, $slug: String!, $description: String,
            $states: JSON!, $transitions: JSON!, $targetType: String
          ) {
            createWorkflowDefinition(
              name: $name, slug: $slug, description: $description,
              states: $states, transitions: $transitions, targetType: $targetType
            ) {
              ok
              workflowDefinition { id name slug states transitions }
              errors { field messages }
            }
          }
        GQL
      end

      it "creates a workflow definition" do
        states = [{ "name" => "open", "initial" => true }, { "name" => "closed" }]
        transitions = [{ "from" => "open", "to" => "closed" }]

        graphql_query(
          mutation,
          variables: {
            name: "Simple Flow",
            slug: "simple-flow",
            description: "A simple two-state flow",
            states: states,
            transitions: transitions
          },
          user: user
        )

        data = graphql_data["createWorkflowDefinition"]
        expect(data["ok"]).to be true
        expect(data["workflowDefinition"]["name"]).to eq("Simple Flow")
        expect(data["workflowDefinition"]["states"].length).to eq(2)
        expect(WorkflowDefinition.find_by(slug: "simple-flow")).to be_present
      end

      it "returns errors for duplicate slug" do
        graphql_query(
          mutation,
          variables: {
            name: "Dupe",
            slug: "approval-flow",
            states: [{ "name" => "x" }],
            transitions: []
          },
          user: user
        )

        data = graphql_data["createWorkflowDefinition"]
        expect(data["ok"]).to be false
        expect(data["errors"]).to be_present
      end

      it "denies creation without workflow.add permission" do
        graphql_query(
          mutation,
          variables: {
            name: "Nope",
            slug: "nope",
            states: [{ "name" => "a" }],
            transitions: []
          },
          user: user_without_perms
        )

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
      end
    end
  end

  describe "workflow instances" do
    describe "mutation createWorkflowInstance" do
      let(:mutation) do
        <<~GQL
          mutation CreateWorkflowInstance($workflowDefinitionSlug: String!) {
            createWorkflowInstance(workflowDefinitionSlug: $workflowDefinitionSlug) {
              ok
              workflowInstance { id currentState availableTransitions }
              errors { field messages }
            }
          }
        GQL
      end

      it "creates an instance in the initial state" do
        graphql_query(mutation, variables: { workflowDefinitionSlug: "approval-flow" }, user: user)

        data = graphql_data["createWorkflowInstance"]
        expect(data["ok"]).to be true
        expect(data["workflowInstance"]["currentState"]).to eq("draft")
        expect(data["workflowInstance"]["availableTransitions"]).to be_an(Array)
        expect(WorkflowInstance.count).to eq(1)
      end

      it "denies creation without workflow.add permission" do
        graphql_query(mutation, variables: { workflowDefinitionSlug: "approval-flow" }, user: user_without_perms)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
      end

      it "returns error for nonexistent workflow definition" do
        graphql_query(mutation, variables: { workflowDefinitionSlug: "nonexistent" }, user: user)

        expect(graphql_errors).to be_present
      end
    end

    describe "mutation transitionWorkflow" do
      let!(:instance) { create(:workflow_instance, workflow_definition: workflow_def, current_state: "draft") }

      let(:mutation) do
        <<~GQL
          mutation TransitionWorkflow($id: ID!, $toState: String!) {
            transitionWorkflow(id: $id, toState: $toState) {
              ok
              workflowInstance { id currentState transitionLogs { fromState toState } }
            }
          }
        GQL
      end

      it "transitions from draft to review" do
        graphql_query(mutation, variables: { id: instance.uuid, toState: "review" }, user: user)

        data = graphql_data["transitionWorkflow"]
        expect(data["ok"]).to be true
        expect(data["workflowInstance"]["currentState"]).to eq("review")
        expect(data["workflowInstance"]["transitionLogs"].length).to eq(1)
        expect(data["workflowInstance"]["transitionLogs"].first["fromState"]).to eq("draft")
        expect(data["workflowInstance"]["transitionLogs"].first["toState"]).to eq("review")
        expect(instance.reload.current_state).to eq("review")
      end

      it "transitions from review to approved" do
        instance.update!(current_state: "review")
        graphql_query(mutation, variables: { id: instance.uuid, toState: "approved" }, user: user)

        data = graphql_data["transitionWorkflow"]
        expect(data["ok"]).to be true
        expect(data["workflowInstance"]["currentState"]).to eq("approved")
      end

      it "transitions from review to rejected" do
        instance.update!(current_state: "review")
        graphql_query(mutation, variables: { id: instance.uuid, toState: "rejected" }, user: user)

        data = graphql_data["transitionWorkflow"]
        expect(data["ok"]).to be true
        expect(data["workflowInstance"]["currentState"]).to eq("rejected")
      end

      it "rejects invalid transition (draft to approved)" do
        graphql_query(mutation, variables: { id: instance.uuid, toState: "approved" }, user: user)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["message"]).to include("Cannot transition")
      end

      it "denies transition without workflow.change permission" do
        graphql_query(mutation, variables: { id: instance.uuid, toState: "review" }, user: user_without_perms)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["message"]).to match(/Not authorized|not authorized/i)
      end

      it "creates a transition log entry" do
        graphql_query(mutation, variables: { id: instance.uuid, toState: "review" }, user: user)

        expect(instance.transition_logs.count).to eq(1)
        log = instance.transition_logs.first
        expect(log.from_state).to eq("draft")
        expect(log.to_state).to eq("review")
      end
    end

    describe "query workflowInstances" do
      let!(:instance) { create(:workflow_instance, workflow_definition: workflow_def) }

      let(:query) do
        <<~GQL
          query WorkflowInstances($workflowDefinitionSlug: String) {
            workflowInstances(workflowDefinitionSlug: $workflowDefinitionSlug) {
              id currentState
              workflowDefinition { name }
            }
          }
        GQL
      end

      it "lists instances for a workflow definition" do
        graphql_query(query, variables: { workflowDefinitionSlug: "approval-flow" }, user: user)

        expect(response).to have_http_status(:ok)
        instances = graphql_data["workflowInstances"]
        expect(instances.length).to eq(1)
        expect(instances.first["currentState"]).to eq("draft")
        expect(instances.first["workflowDefinition"]["name"]).to eq("Approval Flow")
      end

      it "lists all instances when no filter provided" do
        graphql_query(query, user: user)

        expect(response).to have_http_status(:ok)
        expect(graphql_data["workflowInstances"]).to be_present
      end

      it "denies unauthenticated access" do
        graphql_query(query)

        expect(graphql_errors).to be_present
        expect(graphql_errors.first["extensions"]["code"]).to eq("UNAUTHENTICATED")
      end
    end
  end
end
