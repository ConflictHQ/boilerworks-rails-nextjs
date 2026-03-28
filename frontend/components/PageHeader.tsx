"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";
import { routeLabels } from "@/lib/routes";

const toLabel = (segment: string) =>
  routeLabels[segment] ?? segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, " ");

export const PageHeader = () => {
  const pathname = usePathname();
  const segments = pathname.split("/").filter(Boolean);

  const crumbs = segments.map((segment, i) => ({
    label: toLabel(segment),
    href: "/" + segments.slice(0, i + 1).join("/"),
    isLast: i === segments.length - 1,
  }));

  return (
    <header className="border-border flex h-16 shrink-0 items-center gap-2 border-b px-6">
      <nav className="flex items-center gap-1.5 text-sm">
        {crumbs.map((crumb, i) => (
          <span key={crumb.href} className="flex items-center gap-1.5">
            {i > 0 && <span className="text-muted-foreground">/</span>}
            {crumb.isLast ? (
              <span className="text-foreground font-medium">{crumb.label}</span>
            ) : (
              <Link href={crumb.href} className="text-muted-foreground hover:text-foreground">
                {crumb.label}
              </Link>
            )}
          </span>
        ))}
      </nav>
    </header>
  );
};
