export type FormDefinition = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  schema: Record<string, unknown>;
  status: string;
  submissionsCount: number;
  createdAt: string;
  updatedAt: string;
};

export type FormSubmission = {
  id: string;
  formDefinition: { id: string; name: string };
  data: Record<string, unknown>;
  status: string;
  validatedAt: string | null;
  createdAt: string;
};

export type FormDefinitionsQueryData = {
  formDefinitions: FormDefinition[];
};

export type FormDefinitionQueryData = {
  formDefinition: FormDefinition | null;
};
