"use client";

import { useQuery, useMutation } from "@apollo/client/react";
import { GET_CATEGORIES } from "./categories.queries";
import { CREATE_CATEGORY, DELETE_CATEGORY } from "./categories.mutations";
import type { CategoriesQueryData, CreateCategoryData, DeleteCategoryData } from "./categories.types";

export const useCategories = () => {
  const { data, loading, error, refetch } = useQuery<CategoriesQueryData>(GET_CATEGORIES, {
    fetchPolicy: "cache-and-network",
  });

  return {
    categories: data?.categories ?? [],
    loading,
    error,
    refetch,
  };
};

export const useCreateCategory = () =>
  useMutation<CreateCategoryData>(CREATE_CATEGORY, {
    refetchQueries: [{ query: GET_CATEGORIES }],
  });

export const useDeleteCategory = () =>
  useMutation<DeleteCategoryData>(DELETE_CATEGORY, {
    refetchQueries: [{ query: GET_CATEGORIES }],
  });
