import { gql } from "@apollo/client";

export const GET_WORKFLOW_DEFINITIONS = gql`
  query WorkflowDefinitions {
    workflowDefinitions {
      id
      name
      slug
      description
      states
      transitions
      targetType
      instancesCount
      createdAt
      updatedAt
    }
  }
`;

export const GET_WORKFLOW_INSTANCES = gql`
  query WorkflowInstances($workflowDefinitionSlug: String) {
    workflowInstances(workflowDefinitionSlug: $workflowDefinitionSlug) {
      id
      workflowDefinition {
        id
        name
        slug
      }
      currentState
      metadata
      availableTransitions
      transitionLogs {
        id
        fromState
        toState
        createdAt
      }
      createdAt
    }
  }
`;
