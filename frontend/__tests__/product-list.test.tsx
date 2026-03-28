import { describe, it, expect } from 'vitest';
import { render, screen, within } from '@testing-library/react';
import React from 'react';

type Product = {
  id: string;
  name: string;
  price: number | null;
  category: { name: string } | null;
};

/**
 * ProductList: renders a table of products with loading and empty states.
 * Mirrors the real product-listing pattern used in the app.
 */
function ProductList({ products, loading }: { products: Product[]; loading: boolean }) {
  if (loading) {
    return (
      <div role="status" aria-label="Loading products">
        <div data-testid="skeleton-row" />
        <div data-testid="skeleton-row" />
        <div data-testid="skeleton-row" />
      </div>
    );
  }

  if (products.length === 0) {
    return <p>No products found</p>;
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
        {products.map((product) => (
          <tr key={product.id} data-testid="product-row">
            <td>{product.name}</td>
            <td>{product.price != null ? `$${product.price.toFixed(2)}` : '-'}</td>
            <td>{product.category?.name ?? 'Uncategorised'}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

const sampleProducts: Product[] = [
  { id: '1', name: 'Widget', price: 19.99, category: { name: 'Gadgets' } },
  { id: '2', name: 'Gizmo', price: 49.99, category: null },
  { id: '3', name: 'Thingamajig', price: null, category: { name: 'Parts' } },
];

describe('ProductList', () => {
  it('renders loading skeleton when loading is true', () => {
    render(<ProductList products={[]} loading={true} />);
    expect(screen.getByRole('status', { name: 'Loading products' })).toBeDefined();
    expect(screen.getAllByTestId('skeleton-row')).toHaveLength(3);
  });

  it('renders empty state when products array is empty', () => {
    render(<ProductList products={[]} loading={false} />);
    expect(screen.getByText('No products found')).toBeDefined();
  });

  it('renders a row for each product', () => {
    render(<ProductList products={sampleProducts} loading={false} />);
    expect(screen.getAllByTestId('product-row')).toHaveLength(3);
  });

  it('displays product name, formatted price, and category', () => {
    render(<ProductList products={sampleProducts} loading={false} />);
    expect(screen.getByText('Widget')).toBeDefined();
    expect(screen.getByText('$19.99')).toBeDefined();
    expect(screen.getByText('Gadgets')).toBeDefined();
  });

  it('shows dash for null price', () => {
    render(<ProductList products={sampleProducts} loading={false} />);
    const rows = screen.getAllByTestId('product-row');
    const thingRow = rows[2];
    expect(within(thingRow).getByText('-')).toBeDefined();
  });

  it('shows Uncategorised for products without a category', () => {
    render(<ProductList products={sampleProducts} loading={false} />);
    expect(screen.getByText('Uncategorised')).toBeDefined();
  });

  it('renders table headers', () => {
    render(<ProductList products={sampleProducts} loading={false} />);
    expect(screen.getByText('Name')).toBeDefined();
    expect(screen.getByText('Price')).toBeDefined();
    expect(screen.getByText('Category')).toBeDefined();
  });
});
