"use client";

import Link from "next/link";
import { useWorkflowDefinitions } from "@/graphql/workflows/workflows.hooks";

export default function WorkflowsPage() {
  const { workflowDefinitions, loading, error } = useWorkflowDefinitions();

  if (error) return <div className="p-6 text-red-500">Error loading workflows</div>;

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-semibold">Workflows</h1>
          <p className="text-muted-foreground mt-1 text-sm">Design and manage approval workflows.</p>
        </div>
        <Link
          href="/workflows/new"
          className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-md px-4 py-2 text-sm font-medium"
        >
          New Workflow
        </Link>
      </div>
      <hr className="border-border" />

      {loading && workflowDefinitions.length === 0 ? (
        <p className="text-muted-foreground text-sm">Loading workflows...</p>
      ) : (
        <div className="border-border overflow-hidden rounded-lg border">
          <table className="w-full text-sm">
            <thead className="bg-muted/50 border-border border-b">
              <tr>
                <th className="px-4 py-3 text-left font-medium">Name</th>
                <th className="px-4 py-3 text-left font-medium">Slug</th>
                <th className="px-4 py-3 text-left font-medium">States</th>
                <th className="px-4 py-3 text-left font-medium">Instances</th>
              </tr>
            </thead>
            <tbody>
              {workflowDefinitions.map((wf) => (
                <tr key={wf.id} className="border-border border-b last:border-0">
                  <td className="px-4 py-3 font-medium">{wf.name}</td>
                  <td className="text-muted-foreground px-4 py-3">{wf.slug}</td>
                  <td className="px-4 py-3">{wf.states.length} states</td>
                  <td className="px-4 py-3">{wf.instancesCount}</td>
                </tr>
              ))}
              {workflowDefinitions.length === 0 && (
                <tr>
                  <td colSpan={4} className="text-muted-foreground px-4 py-8 text-center">
                    No workflows found
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
