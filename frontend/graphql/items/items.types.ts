export type Item = {
  id: string;
  name: string;
  slug: string | null;
  description: string | null;
  price: number | null;
  category: { id: string; name: string } | null;
  createdAt: string;
  updatedAt: string;
};

export type ItemsQueryData = {
  items: Item[];
};

export type ItemQueryData = {
  item: Item | null;
};

export type CreateItemData = {
  createItem: {
    ok: boolean;
    item: Item | null;
    errors: { field: string; messages: string[] }[] | null;
  };
};

export type UpdateItemData = {
  updateItem: {
    ok: boolean;
    item: Item | null;
    errors: { field: string; messages: string[] }[] | null;
  };
};

export type DeleteItemData = {
  deleteItem: { ok: boolean };
};
