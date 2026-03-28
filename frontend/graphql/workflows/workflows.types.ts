export type WorkflowDefinition = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  states: { name: string; label: string; initial?: boolean }[];
  transitions: { from: string; to: string; label: string }[];
  targetType: string | null;
  instancesCount: number;
  createdAt: string;
  updatedAt: string;
};

export type WorkflowInstance = {
  id: string;
  workflowDefinition: { id: string; name: string; slug: string };
  currentState: string;
  metadata: Record<string, unknown>;
  availableTransitions: { from: string; to: string; label: string }[];
  transitionLogs: { id: string; fromState: string; toState: string; createdAt: string }[];
  createdAt: string;
};

export type WorkflowDefinitionsQueryData = {
  workflowDefinitions: WorkflowDefinition[];
};

export type WorkflowInstancesQueryData = {
  workflowInstances: WorkflowInstance[];
};
