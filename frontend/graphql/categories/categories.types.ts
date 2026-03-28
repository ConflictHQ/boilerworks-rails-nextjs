export type Category = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  productsCount: number;
  createdAt: string;
  updatedAt: string;
};

export type CategoriesQueryData = {
  categories: Category[];
};

export type CreateCategoryData = {
  createCategory: {
    ok: boolean;
    category: Category | null;
    errors: { field: string; messages: string[] }[] | null;
  };
};

export type DeleteCategoryData = {
  deleteCategory: { ok: boolean };
};
