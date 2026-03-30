import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import React from "react";

// Mock next/navigation
vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: vi.fn(), replace: vi.fn(), back: vi.fn() }),
  usePathname: () => "/dashboard",
  useSearchParams: () => new URLSearchParams(),
}));

// Simple components for testing (avoid Apollo dependency in unit tests)
function StatCard({ label, value }: { label: string; value: number }) {
  return (
    <div data-testid="stat-card">
      <span className="label">{label}</span>
      <span className="value">{value}</span>
    </div>
  );
}

function PermissionGate({
  permissions,
  required,
  children,
}: {
  permissions: string[];
  required: string;
  children: React.ReactNode;
}) {
  const allowed = permissions.includes("*") || permissions.includes(required);
  return allowed ? <>{children}</> : null;
}

function NavItem({ href, label, active }: { href: string; label: string; active: boolean }) {
  return (
    <a href={href} className={active ? "active" : ""}>
      {label}
    </a>
  );
}

function FlashMessage({ type, message }: { type: "success" | "error"; message: string }) {
  return (
    <div role="alert" className={`flash-${type}`}>
      {message}
    </div>
  );
}

function LoginForm({ onSubmit }: { onSubmit: (email: string, password: string) => void }) {
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        const form = e.target as HTMLFormElement;
        const email = (form.elements.namedItem("email") as HTMLInputElement).value;
        const password = (form.elements.namedItem("password") as HTMLInputElement).value;
        onSubmit(email, password);
      }}
    >
      <label htmlFor="email">Email</label>
      <input id="email" name="email" type="email" />
      <label htmlFor="password">Password</label>
      <input id="password" name="password" type="password" />
      <button type="submit">Sign in</button>
    </form>
  );
}

describe("StatCard", () => {
  it("renders label and value", () => {
    render(<StatCard label="Items" value={42} />);
    expect(screen.getByText("Items")).toBeDefined();
    expect(screen.getByText("42")).toBeDefined();
  });

  it("renders zero value", () => {
    render(<StatCard label="Empty" value={0} />);
    expect(screen.getByText("0")).toBeDefined();
  });
});

describe("PermissionGate", () => {
  it("renders children when permission granted", () => {
    render(
      <PermissionGate permissions={["items.view"]} required="items.view">
        <span>Visible</span>
      </PermissionGate>
    );
    expect(screen.getByText("Visible")).toBeDefined();
  });

  it("hides children when permission denied", () => {
    render(
      <PermissionGate permissions={["items.view"]} required="items.create">
        <span>Hidden</span>
      </PermissionGate>
    );
    expect(screen.queryByText("Hidden")).toBeNull();
  });

  it("wildcard grants all permissions", () => {
    render(
      <PermissionGate permissions={["*"]} required="anything.here">
        <span>Granted</span>
      </PermissionGate>
    );
    expect(screen.getByText("Granted")).toBeDefined();
  });

  it("empty permissions deny all", () => {
    render(
      <PermissionGate permissions={[]} required="items.view">
        <span>Denied</span>
      </PermissionGate>
    );
    expect(screen.queryByText("Denied")).toBeNull();
  });
});

describe("NavItem", () => {
  it("renders link with label", () => {
    render(<NavItem href="/items" label="Items" active={false} />);
    const link = screen.getByText("Items");
    expect(link).toBeDefined();
    expect(link.getAttribute("href")).toBe("/items");
  });

  it("applies active class when active", () => {
    render(<NavItem href="/dashboard" label="Dashboard" active={true} />);
    expect(screen.getByText("Dashboard").className).toContain("active");
  });

  it("does not apply active class when inactive", () => {
    render(<NavItem href="/items" label="Items" active={false} />);
    expect(screen.getByText("Items").className).not.toContain("active");
  });
});

describe("FlashMessage", () => {
  it("renders success message", () => {
    render(<FlashMessage type="success" message="Created successfully" />);
    expect(screen.getByRole("alert").textContent).toBe("Created successfully");
  });

  it("renders error message", () => {
    render(<FlashMessage type="error" message="Something went wrong" />);
    expect(screen.getByRole("alert").textContent).toBe("Something went wrong");
  });
});

describe("LoginForm", () => {
  it("renders email and password fields", () => {
    render(<LoginForm onSubmit={() => {}} />);
    expect(screen.getByLabelText("Email")).toBeDefined();
    expect(screen.getByLabelText("Password")).toBeDefined();
  });

  it("renders submit button", () => {
    render(<LoginForm onSubmit={() => {}} />);
    expect(screen.getByText("Sign in")).toBeDefined();
  });
});
