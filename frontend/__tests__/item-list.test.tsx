import { describe, it, expect } from "vitest";
import { render, screen, within } from "@testing-library/react";
import React from "react";

type Item = {
  id: string;
  name: string;
  price: number | null;
  category: { name: string } | null;
};

/**
 * ItemList: renders a table of items with loading and empty states.
 * Mirrors the real item-listing pattern used in the app.
 */
function ItemList({ items, loading }: { items: Item[]; loading: boolean }) {
  if (loading) {
    return (
      <div role="status" aria-label="Loading items">
        <div data-testid="skeleton-row" />
        <div data-testid="skeleton-row" />
        <div data-testid="skeleton-row" />
      </div>
    );
  }

  if (items.length === 0) {
    return <p>No items found</p>;
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Price</th>
          <th>Category</th>
        </tr>
      </thead>
      <tbody>
        {items.map((item) => (
          <tr key={item.id} data-testid="item-row">
            <td>{item.name}</td>
            <td>{item.price != null ? `$${item.price.toFixed(2)}` : "-"}</td>
            <td>{item.category?.name ?? "Uncategorised"}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

const sampleItems: Item[] = [
  { id: "1", name: "Widget", price: 19.99, category: { name: "Gadgets" } },
  { id: "2", name: "Gizmo", price: 49.99, category: null },
  { id: "3", name: "Thingamajig", price: null, category: { name: "Parts" } },
];

describe("ItemList", () => {
  it("renders loading skeleton when loading is true", () => {
    render(<ItemList items={[]} loading={true} />);
    expect(screen.getByRole("status", { name: "Loading items" })).toBeDefined();
    expect(screen.getAllByTestId("skeleton-row")).toHaveLength(3);
  });

  it("renders empty state when items array is empty", () => {
    render(<ItemList items={[]} loading={false} />);
    expect(screen.getByText("No items found")).toBeDefined();
  });

  it("renders a row for each item", () => {
    render(<ItemList items={sampleItems} loading={false} />);
    expect(screen.getAllByTestId("item-row")).toHaveLength(3);
  });

  it("displays item name, formatted price, and category", () => {
    render(<ItemList items={sampleItems} loading={false} />);
    expect(screen.getByText("Widget")).toBeDefined();
    expect(screen.getByText("$19.99")).toBeDefined();
    expect(screen.getByText("Gadgets")).toBeDefined();
  });

  it("shows dash for null price", () => {
    render(<ItemList items={sampleItems} loading={false} />);
    const rows = screen.getAllByTestId("item-row");
    const thingRow = rows[2];
    expect(within(thingRow).getByText("-")).toBeDefined();
  });

  it("shows Uncategorised for items without a category", () => {
    render(<ItemList items={sampleItems} loading={false} />);
    expect(screen.getByText("Uncategorised")).toBeDefined();
  });

  it("renders table headers", () => {
    render(<ItemList items={sampleItems} loading={false} />);
    expect(screen.getByText("Name")).toBeDefined();
    expect(screen.getByText("Price")).toBeDefined();
    expect(screen.getByText("Category")).toBeDefined();
  });
});
