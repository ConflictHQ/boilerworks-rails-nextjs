"use client";

import { useQuery, useMutation } from "@apollo/client/react";
import { GET_WORKFLOW_DEFINITIONS, GET_WORKFLOW_INSTANCES } from "./workflows.queries";
import {
  CREATE_WORKFLOW_DEFINITION,
  CREATE_WORKFLOW_INSTANCE,
  TRANSITION_WORKFLOW,
} from "./workflows.mutations";
import type { WorkflowDefinitionsQueryData, WorkflowInstancesQueryData } from "./workflows.types";

export const useWorkflowDefinitions = () => {
  const { data, loading, error, refetch } = useQuery<WorkflowDefinitionsQueryData>(
    GET_WORKFLOW_DEFINITIONS,
    { fetchPolicy: "cache-and-network" }
  );
  return { workflowDefinitions: data?.workflowDefinitions ?? [], loading, error, refetch };
};

export const useWorkflowInstances = (workflowDefinitionSlug?: string) => {
  const { data, loading, error, refetch } = useQuery<WorkflowInstancesQueryData>(
    GET_WORKFLOW_INSTANCES,
    {
      variables: { workflowDefinitionSlug },
      fetchPolicy: "cache-and-network",
    }
  );
  return { workflowInstances: data?.workflowInstances ?? [], loading, error, refetch };
};

export const useCreateWorkflowDefinition = () =>
  useMutation(CREATE_WORKFLOW_DEFINITION, {
    refetchQueries: [{ query: GET_WORKFLOW_DEFINITIONS }],
  });

export const useCreateWorkflowInstance = () =>
  useMutation(CREATE_WORKFLOW_INSTANCE, {
    refetchQueries: [{ query: GET_WORKFLOW_INSTANCES }],
  });

export const useTransitionWorkflow = () =>
  useMutation(TRANSITION_WORKFLOW, {
    refetchQueries: [{ query: GET_WORKFLOW_INSTANCES }],
  });
