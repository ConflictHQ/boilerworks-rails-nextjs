"use client";

import { useQuery, useMutation } from "@apollo/client/react";
import { GET_PRODUCTS } from "./products.queries";
import { CREATE_PRODUCT, UPDATE_PRODUCT, DELETE_PRODUCT } from "./products.mutations";
import type { ProductsQueryData, CreateProductData, UpdateProductData, DeleteProductData } from "./products.types";

export const useProducts = (search?: string, categoryId?: string) => {
  const { data, loading, error, refetch } = useQuery<ProductsQueryData>(GET_PRODUCTS, {
    variables: { search, categoryId },
    fetchPolicy: "cache-and-network",
  });

  return {
    products: data?.products ?? [],
    loading,
    error,
    refetch,
  };
};

export const useCreateProduct = () =>
  useMutation<CreateProductData>(CREATE_PRODUCT, {
    refetchQueries: [{ query: GET_PRODUCTS }],
  });

export const useUpdateProduct = () =>
  useMutation<UpdateProductData>(UPDATE_PRODUCT, {
    refetchQueries: [{ query: GET_PRODUCTS }],
  });

export const useDeleteProduct = () =>
  useMutation<DeleteProductData>(DELETE_PRODUCT, {
    refetchQueries: [{ query: GET_PRODUCTS }],
  });
