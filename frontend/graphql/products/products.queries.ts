import { gql } from "@apollo/client";

export const GET_PRODUCTS = gql`
  query Products($search: String, $categoryId: ID) {
    products(search: $search, categoryId: $categoryId) {
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

export const GET_PRODUCT = gql`
  query Product($id: ID!) {
    product(id: $id) {
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
