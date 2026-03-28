"use client";

import { useState } from "react";
import { useCategories, useCreateCategory, useDeleteCategory } from "@/graphql/categories/categories.hooks";
import { toast } from "sonner";

export default function CategoriesPage() {
  const { categories, loading, error } = useCategories();
  const [createCategory] = useCreateCategory();
  const [deleteCategory] = useDeleteCategory();
  const [showForm, setShowForm] = useState(false);
  const [name, setName] = useState("");
  const [slug, setSlug] = useState("");
  const [description, setDescription] = useState("");

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault();
    const { data } = await createCategory({ variables: { name, slug, description: description || null } });
    if (data?.createCategory.ok) {
      toast.success("Category created");
      setName("");
      setSlug("");
      setDescription("");
      setShowForm(false);
    } else {
      const errs = data?.createCategory.errors;
      toast.error(errs?.[0]?.messages[0] ?? "Failed to create category");
    }
  };

  const handleDelete = async (id: string) => {
    const { data } = await deleteCategory({ variables: { id } });
    if (data?.deleteCategory.ok) {
      toast.success("Category deleted");
    }
  };

  if (error) return <div className="p-6 text-red-500">Error loading categories</div>;

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Categories</h1>
          <p className="text-muted-foreground mt-1 text-sm">Organize products into categories.</p>
        </div>
        <button
          onClick={() => setShowForm(!showForm)}
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          {showForm ? "Cancel" : "Add Category"}
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
              <label className="text-sm font-medium">Slug</label>
              <input
                value={slug}
                onChange={(e) => setSlug(e.target.value)}
                required
                className="border-input bg-background mt-1 flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            </div>
            <div>
              <label className="text-sm font-medium">Description</label>
              <input
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="border-input bg-background mt-1 flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            </div>
          </div>
          <button
            type="submit"
            className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
          >
            Create Category
          </button>
        </form>
      )}

      {loading && categories.length === 0 ? (
        <p className="text-muted-foreground text-sm">Loading categories...</p>
      ) : (
        <div className="border-border overflow-hidden rounded-lg border">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 border-border border-b">
              <tr>
                <th className="px-4 py-3 text-left font-medium">Name</th>
                <th className="px-4 py-3 text-left font-medium">Slug</th>
                <th className="px-4 py-3 text-left font-medium">Products</th>
                <th className="px-4 py-3 text-right font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {categories.map((cat) => (
                <tr key={cat.id} className="border-border border-b last:border-0">
                  <td className="px-4 py-3 font-medium">{cat.name}</td>
                  <td className="text-muted-foreground px-4 py-3">{cat.slug}</td>
                  <td className="px-4 py-3">{cat.productsCount}</td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleDelete(cat.id)}
                      className="text-destructive hover:text-destructive/80 text-xs"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
              {categories.length === 0 && (
                <tr>
                  <td colSpan={4} className="text-muted-foreground px-4 py-8 text-center">
                    No categories found
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
