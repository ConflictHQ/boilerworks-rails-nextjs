"use client";

import { useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useFormDefinition, useCreateFormSubmission } from "@/graphql/forms/forms.hooks";
import { toast } from "sonner";

export default function FormSubmitPage() {
  const params = useParams();
  const router = useRouter();
  const slug = params.slug as string;
  const { formDefinition, loading, error } = useFormDefinition(slug);
  const [submitForm] = useCreateFormSubmission();
  const [formData, setFormData] = useState<Record<string, string>>({});

  if (loading) return <div className="p-6 text-sm">Loading...</div>;
  if (error) return <div className="p-6 text-red-500">Error loading form</div>;
  if (!formDefinition) return <div className="p-6">Form not found</div>;

  const fields = (formDefinition.schema as { fields?: { name: string; type: string; label: string }[] })?.fields ?? [];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const { data } = await submitForm({
      variables: { formDefinitionSlug: slug, data: formData },
    });
    if (data?.createFormSubmission.ok) {
      toast.success("Form submitted");
      router.push(`/forms/${slug}`);
    } else {
      toast.error("Submission failed");
    }
  };

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div>
        <h1 className="text-xl font-semibold">{formDefinition.name}</h1>
        <p className="text-muted-foreground mt-1 text-sm">Fill out and submit this form.</p>
      </div>
      <hr className="border-border" />
      <form onSubmit={handleSubmit} className="max-w-xl space-y-4">
        {fields.map((field) => (
          <div key={field.name} className="space-y-2">
            <label className="text-sm font-medium">{field.label}</label>
            {field.type === "textarea" ? (
              <textarea
                value={formData[field.name] ?? ""}
                onChange={(e) => setFormData({ ...formData, [field.name]: e.target.value })}
                rows={3}
                className="border-input bg-background flex w-full rounded-md border px-3 py-2 text-sm"
              />
            ) : (
              <input
                type={field.type === "email" ? "email" : field.type === "number" ? "number" : "text"}
                value={formData[field.name] ?? ""}
                onChange={(e) => setFormData({ ...formData, [field.name]: e.target.value })}
                className="border-input bg-background flex h-10 w-full rounded-md border px-3 py-2 text-sm"
              />
            )}
          </div>
        ))}
        <button
          type="submit"
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          Submit
        </button>
      </form>
    </div>
  );
}
