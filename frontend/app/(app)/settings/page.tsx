"use client";

import { useMe } from "@/graphql/user/user.hooks";

export default function SettingsPage() {
  const { user, loading } = useMe();

  return (
    <div className="flex flex-1 flex-col gap-6 p-6">
      <div>
        <h1 className="text-xl font-semibold">Settings</h1>
        <p className="text-muted-foreground mt-1 text-sm">Account and application settings.</p>
      </div>
      <hr className="border-border" />
      {loading ? (
        <p className="text-muted-foreground text-sm">Loading...</p>
      ) : user ? (
        <div className="bg-card border-border max-w-xl rounded-lg border p-6">
          <h2 className="mb-4 text-lg font-medium">Profile</h2>
          <div className="space-y-3 text-sm">
            <div className="flex justify-between">
              <span className="text-muted-foreground">Name</span>
              <span className="font-medium">{user.displayName}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Email</span>
              <span className="font-medium">{user.email}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Permissions</span>
              <span className="font-medium">{user.permissions.length}</span>
            </div>
          </div>
        </div>
      ) : (
        <p className="text-muted-foreground text-sm">Not authenticated</p>
      )}
    </div>
  );
}
