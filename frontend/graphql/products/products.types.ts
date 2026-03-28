export type Product = {
  id: string;
  name: string;
  slug: string | null;
  description: string | null;
  price: number | null;
  category: { id: string; name: string } | null;
  createdAt: string;
  updatedAt: string;
};

export type ProductsQueryData = {
  products: Product[];
};

export type ProductQueryData = {
  product: Product | null;
};

export type CreateProductData = {
  createProduct: {
    ok: boolean;
    product: Product | null;
    errors: { field: string; messages: string[] }[] | null;
  };
};

export type UpdateProductData = {
  updateProduct: {
    ok: boolean;
    product: Product | null;
    errors: { field: string; messages: string[] }[] | null;
  };
};

export type DeleteProductData = {
  deleteProduct: { ok: boolean };
};
