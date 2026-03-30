"use client";

import { useQuery, useMutation } from "@apollo/client/react";
import { GET_FORM_DEFINITIONS, GET_FORM_DEFINITION } from "./forms.queries";
import {
  CREATE_FORM_DEFINITION,
  PUBLISH_FORM_DEFINITION,
  CREATE_FORM_SUBMISSION,
} from "./forms.mutations";
import type { FormDefinitionsQueryData, FormDefinitionQueryData } from "./forms.types";

export const useFormDefinitions = () => {
  const { data, loading, error, refetch } = useQuery<FormDefinitionsQueryData>(
    GET_FORM_DEFINITIONS,
    { fetchPolicy: "cache-and-network" }
  );
  return { formDefinitions: data?.formDefinitions ?? [], loading, error, refetch };
};

export const useFormDefinition = (slug: string) => {
  const { data, loading, error } = useQuery<FormDefinitionQueryData>(GET_FORM_DEFINITION, {
    variables: { slug },
    fetchPolicy: "cache-and-network",
  });
  return { formDefinition: data?.formDefinition ?? null, loading, error };
};

export const useCreateFormDefinition = () =>
  useMutation(CREATE_FORM_DEFINITION, {
    refetchQueries: [{ query: GET_FORM_DEFINITIONS }],
  });

export const usePublishFormDefinition = () =>
  useMutation(PUBLISH_FORM_DEFINITION, {
    refetchQueries: [{ query: GET_FORM_DEFINITIONS }],
  });

export const useCreateFormSubmission = () => useMutation(CREATE_FORM_SUBMISSION);
