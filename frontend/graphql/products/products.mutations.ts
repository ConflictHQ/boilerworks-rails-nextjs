import { gql } from "@apollo/client";

export const CREATE_PRODUCT = gql`
  mutation CreateProduct($name: String!, $description: String, $price: Float, $slug: String, $categoryId: ID) {
    createProduct(name: $name, description: $description, price: $price, slug: $slug, categoryId: $categoryId) {
      ok
      product {
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

export const UPDATE_PRODUCT = gql`
  mutation UpdateProduct($id: ID!, $name: String, $description: String, $price: Float, $slug: String, $categoryId: ID) {
    updateProduct(id: $id, name: $name, description: $description, price: $price, slug: $slug, categoryId: $categoryId) {
      ok
      product {
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

export const DELETE_PRODUCT = gql`
  mutation DeleteProduct($id: ID!) {
    deleteProduct(id: $id) {
      ok
    }
  }
`;
