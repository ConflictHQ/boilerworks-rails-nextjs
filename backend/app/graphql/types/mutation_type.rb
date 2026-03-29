module Types
  class MutationType < Types::BaseObject
    # Items
    field :create_item, mutation: Mutations::CreateItem
    field :update_item, mutation: Mutations::UpdateItem
    field :delete_item, mutation: Mutations::DeleteItem

    # Categories
    field :create_category, mutation: Mutations::CreateCategory
    field :update_category, mutation: Mutations::UpdateCategory
    field :delete_category, mutation: Mutations::DeleteCategory

    # Form Definitions
    field :create_form_definition, mutation: Mutations::CreateFormDefinition
    field :update_form_definition, mutation: Mutations::UpdateFormDefinition
    field :publish_form_definition, mutation: Mutations::PublishFormDefinition

    # Form Submissions
    field :create_form_submission, mutation: Mutations::CreateFormSubmission

    # Workflow Definitions
    field :create_workflow_definition, mutation: Mutations::CreateWorkflowDefinition
    field :update_workflow_definition, mutation: Mutations::UpdateWorkflowDefinition

    # Workflow Instances
    field :create_workflow_instance, mutation: Mutations::CreateWorkflowInstance
    field :transition_workflow, mutation: Mutations::TransitionWorkflow
  end
end
