"use client";

import Link from "next/link";
import { useFormDefinitions } from "@/graphql/forms/forms.hooks";

export default function FormsPage() {
  const { formDefinitions, loading, error } = useFormDefinitions();

  if (error) return <div className="p-6 text-red-500">Error loading forms</div>;

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Form Engine</h1>
          <p className="text-muted-foreground mt-1 text-sm">Build and manage dynamic forms.</p>
        </div>
        <Link
          href="/forms/new"
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          Create Form
        </Link>
      </div>
      <hr className="border-border" />

      {loading && formDefinitions.length === 0 ? (
        <p className="text-muted-foreground text-sm">Loading forms...</p>
      ) : (
        <div className="border-border overflow-hidden rounded-lg border">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 border-border border-b">
              <tr>
                <th className="px-4 py-3 text-left font-medium">Name</th>
                <th className="px-4 py-3 text-left font-medium">Slug</th>
                <th className="px-4 py-3 text-left font-medium">Status</th>
                <th className="px-4 py-3 text-left font-medium">Submissions</th>
                <th className="px-4 py-3 text-right font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {formDefinitions.map((form) => (
                <tr key={form.id} className="border-border border-b last:border-0">
                  <td className="px-4 py-3 font-medium">{form.name}</td>
                  <td className="text-muted-foreground px-4 py-3">{form.slug}</td>
                  <td className="px-4 py-3">
                    <span
                      className={`inline-flex rounded-full px-2 py-0.5 text-xs font-medium ${
                        form.status === "published"
                          ? "bg-green-500/10 text-green-500"
                          : form.status === "draft"
                            ? "bg-yellow-500/10 text-yellow-500"
                            : "bg-muted text-muted-foreground"
                      }`}
                    >
                      {form.status}
                    </span>
                  </td>
                  <td className="px-4 py-3">{form.submissionsCount}</td>
                  <td className="px-4 py-3 text-right">
                    <Link href={`/forms/${form.slug}`} className="text-primary text-xs hover:underline">
                      View
                    </Link>
                    {form.status === "published" && (
                      <Link
                        href={`/forms/${form.slug}/submit`}
                        className="text-primary ml-3 text-xs hover:underline"
                      >
                        Fill Out
                      </Link>
                    )}
                  </td>
                </tr>
              ))}
              {formDefinitions.length === 0 && (
                <tr>
                  <td colSpan={5} className="text-muted-foreground px-4 py-8 text-center">
                    No forms found
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
