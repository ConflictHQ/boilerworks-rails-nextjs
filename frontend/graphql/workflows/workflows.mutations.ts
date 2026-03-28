import { gql } from "@apollo/client";

export const CREATE_WORKFLOW_DEFINITION = gql`
  mutation CreateWorkflowDefinition(
    $name: String!
    $slug: String!
    $description: String
    $states: JSON!
    $transitions: JSON!
    $targetType: String
  ) {
    createWorkflowDefinition(
      name: $name
      slug: $slug
      description: $description
      states: $states
      transitions: $transitions
      targetType: $targetType
    ) {
      ok
      workflowDefinition {
        id
        name
        slug
      }
      errors {
        field
        messages
      }
    }
  }
`;

export const CREATE_WORKFLOW_INSTANCE = gql`
  mutation CreateWorkflowInstance($workflowDefinitionSlug: String!) {
    createWorkflowInstance(workflowDefinitionSlug: $workflowDefinitionSlug) {
      ok
      workflowInstance {
        id
        currentState
      }
      errors {
        field
        messages
      }
    }
  }
`;

export const TRANSITION_WORKFLOW = gql`
  mutation TransitionWorkflow($id: ID!, $toState: String!) {
    transitionWorkflow(id: $id, toState: $toState) {
      ok
      workflowInstance {
        id
        currentState
        availableTransitions
        transitionLogs {
          id
          fromState
          toState
          createdAt
        }
      }
    }
  }
`;
