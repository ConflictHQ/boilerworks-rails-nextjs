import { gql } from "@apollo/client";

export const CREATE_ITEM = gql`
  mutation CreateItem($name: String!, $description: String, $price: Float, $slug: String, $categoryId: ID) {
    createItem(name: $name, description: $description, price: $price, slug: $slug, categoryId: $categoryId) {
      ok
      item {
        id
        name
        slug
        price
      }
      errors {
        field
        messages
      }
    }
  }
`;

export const UPDATE_ITEM = gql`
  mutation UpdateItem($id: ID!, $name: String, $description: String, $price: Float, $slug: String, $categoryId: ID) {
    updateItem(id: $id, name: $name, description: $description, price: $price, slug: $slug, categoryId: $categoryId) {
      ok
      item {
        id
        name
        slug
        price
      }
      errors {
        field
        messages
      }
    }
  }
`;

export const DELETE_ITEM = gql`
  mutation DeleteItem($id: ID!) {
    deleteItem(id: $id) {
      ok
    }
  }
`;
