import { gql } from "@apollo/client";

export const CREATE_FORM_DEFINITION = gql`
  mutation CreateFormDefinition(
    $name: String!
    $slug: String!
    $description: String
    $schema: JSON
  ) {
    createFormDefinition(name: $name, slug: $slug, description: $description, schema: $schema) {
      ok
      formDefinition {
        id
        name
        slug
        status
      }
      errors {
        field
        messages
      }
    }
  }
`;

export const PUBLISH_FORM_DEFINITION = gql`
  mutation PublishFormDefinition($slug: String!) {
    publishFormDefinition(slug: $slug) {
      ok
      formDefinition {
        id
        status
      }
    }
  }
`;

export const CREATE_FORM_SUBMISSION = gql`
  mutation CreateFormSubmission($formDefinitionSlug: String!, $data: JSON!) {
    createFormSubmission(formDefinitionSlug: $formDefinitionSlug, data: $data) {
      ok
      formSubmission {
        id
        status
      }
      errors {
        field
        messages
      }
    }
  }
`;
