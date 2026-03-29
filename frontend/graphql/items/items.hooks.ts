"use client";

import { useQuery, useMutation } from "@apollo/client/react";
import { GET_ITEMS } from "./items.queries";
import { CREATE_ITEM, UPDATE_ITEM, DELETE_ITEM } from "./items.mutations";
import type { ItemsQueryData, CreateItemData, UpdateItemData, DeleteItemData } from "./items.types";

export const useItems = (search?: string, categoryId?: string) => {
  const { data, loading, error, refetch } = useQuery<ItemsQueryData>(GET_ITEMS, {
    variables: { search, categoryId },
    fetchPolicy: "cache-and-network",
  });

  return {
    items: data?.items ?? [],
    loading,
    error,
    refetch,
  };
};

export const useCreateItem = () =>
  useMutation<CreateItemData>(CREATE_ITEM, {
    refetchQueries: [{ query: GET_ITEMS }],
  });

export const useUpdateItem = () =>
  useMutation<UpdateItemData>(UPDATE_ITEM, {
    refetchQueries: [{ query: GET_ITEMS }],
  });

export const useDeleteItem = () =>
  useMutation<DeleteItemData>(DELETE_ITEM, {
    refetchQueries: [{ query: GET_ITEMS }],
  });
