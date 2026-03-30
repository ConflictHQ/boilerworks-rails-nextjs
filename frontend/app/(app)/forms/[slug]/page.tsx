"use client";

import { useParams } from "next/navigation";
import { useFormDefinition } from "@/graphql/forms/forms.hooks";

export default function FormDetailPage() {
  const params = useParams();
  const slug = params.slug as string;
  const { formDefinition, loading, error } = useFormDefinition(slug);

  if (loading) return <div className="p-6 text-sm">Loading...</div>;
  if (error) return <div className="p-6 text-red-500">Error loading form</div>;
  if (!formDefinition) return <div className="p-6">Form not found</div>;

  const fields =
    (formDefinition.schema as { fields?: { name: string; type: string; label: string }[] })
      ?.fields ?? [];

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div>
        <h1 className="text-xl font-semibold">{formDefinition.name}</h1>
        <p className="text-muted-foreground mt-1 text-sm">{formDefinition.description}</p>
        <span
          className={`mt-2 inline-flex rounded-full px-2 py-0.5 text-xs font-medium ${
            formDefinition.status === "published"
              ? "bg-green-500/10 text-green-500"
              : "bg-yellow-500/10 text-yellow-500"
          }`}
        >
          {formDefinition.status}
        </span>
      </div>
      <hr className="border-border" />
      <div>
        <h2 className="mb-3 text-lg font-medium">Fields ({fields.length})</h2>
        <div className="space-y-2">
          {fields.map((field, i) => (
            <div
              key={i}
              className="bg-card border-border flex items-center gap-4 rounded-lg border p-3"
            >
              <span className="bg-muted rounded px-2 py-1 font-mono text-xs">{field.type}</span>
              <span className="font-medium">{field.label}</span>
              <span className="text-muted-foreground text-sm">{field.name}</span>
            </div>
          ))}
          {fields.length === 0 && (
            <p className="text-muted-foreground text-sm">No fields defined yet.</p>
          )}
        </div>
      </div>
    </div>
  );
}
