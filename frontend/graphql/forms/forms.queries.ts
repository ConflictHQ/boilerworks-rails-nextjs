import { gql } from "@apollo/client";

export const GET_FORM_DEFINITIONS = gql`
  query FormDefinitions {
    formDefinitions {
      id
      name
      slug
      description
      status
      submissionsCount
      createdAt
      updatedAt
    }
  }
`;

export const GET_FORM_DEFINITION = gql`
  query FormDefinition($slug: String!) {
    formDefinition(slug: $slug) {
      id
      name
      slug
      description
      schema
      status
      submissionsCount
      createdAt
      updatedAt
    }
  }
`;

export const GET_FORM_SUBMISSIONS = gql`
  query FormSubmissions($formDefinitionSlug: String) {
    formSubmissions(formDefinitionSlug: $formDefinitionSlug) {
      id
      formDefinition {
        id
        name
      }
      data
      status
      validatedAt
      createdAt
    }
  }
`;
