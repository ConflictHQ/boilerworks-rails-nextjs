import { gql } from "@apollo/client";

export const CREATE_CATEGORY = gql`
  mutation CreateCategory($name: String!, $slug: String!, $description: String) {
    createCategory(name: $name, slug: $slug, description: $description) {
      ok
      category {
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

export const DELETE_CATEGORY = gql`
  mutation DeleteCategory($id: ID!) {
    deleteCategory(id: $id) {
      ok
    }
  }
`;
