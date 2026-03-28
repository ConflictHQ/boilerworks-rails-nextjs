"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useCreateWorkflowDefinition } from "@/graphql/workflows/workflows.hooks";
import { toast } from "sonner";

export default function NewWorkflowPage() {
  const router = useRouter();
  const [createWorkflow] = useCreateWorkflowDefinition();
  const [name, setName] = useState("");
  const [slug, setSlug] = useState("");
  const [description, setDescription] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const { data } = await createWorkflow({
      variables: {
        name,
        slug,
        description: description || null,
        states: [
          { name: "draft", initial: true, label: "Draft" },
          { name: "in_review", label: "In Review" },
          { name: "approved", label: "Approved" },
        ],
        transitions: [
          { from: "draft", to: "in_review", label: "Submit" },
          { from: "in_review", to: "approved", label: "Approve" },
          { from: "in_review", to: "draft", label: "Reject" },
        ],
      },
    });
    if (data?.createWorkflowDefinition.ok) {
      toast.success("Workflow created");
      router.push("/workflows");
    } else {
      toast.error("Failed to create workflow");
    }
  };

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div>
        <h1 className="text-xl font-semibold">New Workflow</h1>
        <p className="text-muted-foreground mt-1 text-sm">Create a new workflow definition with default states.</p>
      </div>
      <hr className="border-border" />
      <form onSubmit={handleSubmit} className="max-w-xl space-y-4">
        <div className="space-y-2">
          <label className="text-sm font-medium">Name</label>
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
            className="border-input bg-background flex h-10 w-full rounded-md border px-3 py-2 text-sm"
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Slug</label>
          <input
            value={slug}
            onChange={(e) => setSlug(e.target.value)}
            required
            className="border-input bg-background flex h-10 w-full rounded-md border px-3 py-2 text-sm"
          />
        </div>
        <div className="space-y-2">
          <label className="text-sm font-medium">Description</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            rows={3}
            className="border-input bg-background flex w-full rounded-md border px-3 py-2 text-sm"
          />
        </div>
        <button
          type="submit"
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          Create Workflow
        </button>
      </form>
    </div>
  );
}
