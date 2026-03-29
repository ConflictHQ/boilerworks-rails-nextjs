"use client";

import { useMe } from "@/graphql/user/user.hooks";

export default function DashboardPage() {
  const { user, loading } = useMe();

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div>
        <h1 className="text-xl font-semibold">Dashboard</h1>
        <p className="text-muted-foreground mt-1 text-sm">
          {loading ? "Loading..." : `Welcome back, ${user?.displayName ?? "User"}`}
        </p>
      </div>
      <hr className="border-border" />
      <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
        <DashboardCard title="Items" description="Manage your item catalogue" href="/items" />
        <DashboardCard title="Categories" description="Organize items into categories" href="/categories" />
        <DashboardCard title="Form Engine" description="Build and manage dynamic forms" href="/forms" />
        <DashboardCard title="Workflows" description="Design approval workflows" href="/workflows" />
      </div>
    </div>
  );
}

function DashboardCard({ title, description, href }: { title: string; description: string; href: string }) {
  return (
    <a
      href={href}
      className="bg-card text-card-foreground border-border hover:bg-accent rounded-lg border p-6 transition-colors"
    >
      <h3 className="font-semibold">{title}</h3>
      <p className="text-muted-foreground mt-1 text-sm">{description}</p>
    </a>
  );
}
