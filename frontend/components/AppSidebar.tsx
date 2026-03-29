"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useMe } from "@/graphql/user/user.hooks";
import {
  LayoutDashboardIcon,
  PackageIcon,
  FolderIcon,
  ClipboardListIcon,
  ZapIcon,
  Settings2Icon,
  LogOutIcon,
  UserIcon,
} from "lucide-react";

const navItems = [
  { title: "Dashboard", url: "/dashboard", icon: LayoutDashboardIcon },
  { title: "Items", url: "/items", icon: PackageIcon },
  { title: "Categories", url: "/categories", icon: FolderIcon },
  { title: "Form Engine", url: "/forms", icon: ClipboardListIcon },
  { title: "Workflows", url: "/workflows", icon: ZapIcon },
  { title: "Settings", url: "/settings", icon: Settings2Icon },
];

export function AppSidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { user } = useMe();

  const handleLogout = async () => {
    const apiRoot = process.env.NEXT_PUBLIC_API_ROOT ?? "http://localhost:3001";
    await fetch(`${apiRoot}/auth/logout`, { method: "DELETE", credentials: "include" });
    router.push("/auth/login");
  };

  return (
    <aside className="bg-sidebar text-sidebar-foreground border-sidebar-border flex w-64 flex-col border-r">
      <div className="border-sidebar-border flex h-16 items-center border-b px-6">
        <Link href="/dashboard" className="text-lg font-bold">
          Boilerworks
        </Link>
      </div>
      <nav className="flex-1 space-y-1 px-3 py-4">
        {navItems.map((item) => {
          const isActive = pathname.startsWith(item.url);
          return (
            <Link
              key={item.url}
              href={item.url}
              className={`flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors ${
                isActive
                  ? "bg-sidebar-accent text-sidebar-accent-foreground"
                  : "text-sidebar-foreground/70 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"
              }`}
            >
              <item.icon className="h-4 w-4" />
              {item.title}
            </Link>
          );
        })}
      </nav>
      <div className="border-sidebar-border border-t p-3">
        <div className="flex items-center gap-3 px-3 py-2">
          <div className="bg-sidebar-accent flex h-8 w-8 items-center justify-center rounded-full">
            <UserIcon className="h-4 w-4" />
          </div>
          <div className="flex-1 truncate text-sm">
            <p className="font-medium">{user?.displayName ?? "User"}</p>
            <p className="text-sidebar-foreground/50 truncate text-xs">{user?.email ?? ""}</p>
          </div>
          <button
            onClick={handleLogout}
            className="text-sidebar-foreground/50 hover:text-sidebar-foreground"
            title="Sign out"
          >
            <LogOutIcon className="h-4 w-4" />
          </button>
        </div>
      </div>
    </aside>
  );
}
