"use client";

import { useState } from "react";
import { useProducts, useCreateProduct, useDeleteProduct } from "@/graphql/products/products.hooks";
import { toast } from "sonner";

export default function ProductsPage() {
  const { products, loading, error } = useProducts();
  const [createProduct] = useCreateProduct();
  const [deleteProduct] = useDeleteProduct();
  const [showForm, setShowForm] = useState(false);
  const [name, setName] = useState("");
  const [price, setPrice] = useState("");
  const [slug, setSlug] = useState("");

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    const { data } = await createProduct({
      variables: { name, price: price ? parseFloat(price) : null, slug: slug || null },
    });
    if (data?.createProduct.ok) {
      toast.success("Product created");
      setName("");
      setPrice("");
      setSlug("");
      setShowForm(false);
    } else {
      const errs = data?.createProduct.errors;
      toast.error(errs?.[0]?.messages[0] ?? "Failed to create product");
    }
  };

  const handleDelete = async (id: string) => {
    const { data } = await deleteProduct({ variables: { id } });
    if (data?.deleteProduct.ok) {
      toast.success("Product deleted");
    }
  };

  if (error) return <div className="p-6 text-red-500">Error loading products</div>;

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Products</h1>
          <p className="text-muted-foreground mt-1 text-sm">Manage your product catalogue.</p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          {showForm ? "Cancel" : "Add Product"}
        </button>
      </div>
      <hr className="border-border" />

      {showForm && (
        <form onSubmit={handleCreate} className="bg-card border-border space-y-4 rounded-lg border p-4">
          <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
            <div>
              <label className="text-sm font-medium">Name</label>
              <input
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                className="border-input bg-background mt-1 flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Price</label>
              <input
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                type="number"
                step="0.01"
                className="border-input bg-background mt-1 flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Slug</label>
              <input
                value={slug}
                onChange={(e) => setSlug(e.target.value)}
                className="border-input bg-background mt-1 flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            </div>
          </div>
          <button
            type="submit"
            className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
          >
            Create Product
          </button>
        </form>
      )}

      {loading && products.length === 0 ? (
        <p className="text-muted-foreground text-sm">Loading products...</p>
      ) : (
        <div className="border-border overflow-hidden rounded-lg border">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 border-border border-b">
              <tr>
                <th className="px-4 py-3 text-left font-medium">Name</th>
                <th className="px-4 py-3 text-left font-medium">Slug</th>
                <th className="px-4 py-3 text-left font-medium">Price</th>
                <th className="px-4 py-3 text-left font-medium">Category</th>
                <th className="px-4 py-3 text-right font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.id} className="border-border border-b last:border-0">
                  <td className="px-4 py-3 font-medium">{product.name}</td>
                  <td className="text-muted-foreground px-4 py-3">{product.slug ?? "-"}</td>
                  <td className="px-4 py-3">{product.price != null ? `$${product.price.toFixed(2)}` : "-"}</td>
                  <td className="text-muted-foreground px-4 py-3">{product.category?.name ?? "-"}</td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleDelete(product.id)}
                      className="text-destructive hover:text-destructive/80 text-xs"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
              {products.length === 0 && (
                <tr>
                  <td colSpan={5} className="text-muted-foreground px-4 py-8 text-center">
                    No products found
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
