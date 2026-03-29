import { gql } from "@apollo/client";

export const GET_ITEMS = gql`
  query Items($search: String, $categoryId: ID) {
    items(search: $search, categoryId: $categoryId) {
      id
      name
      slug
      description
      price
      category {
        id
        name
      }
      createdAt
      updatedAt
    }
  }
`;

export const GET_ITEM = gql`
  query Item($id: ID!) {
    item(id: $id) {
      id
      name
      slug
      description
      price
      category {
        id
        name
      }
      createdAt
      updatedAt
    }
  }
`;
