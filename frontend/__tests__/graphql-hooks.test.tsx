import { describe, it, expect, vi } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import React from 'react';
import { MockedProvider } from '@apollo/client/testing/react';
import { InMemoryCache } from '@apollo/client';
import { GET_ITEMS } from '@/graphql/items/items.queries';
import { GET_ME } from '@/graphql/user/user.queries';
import { useItems } from '@/graphql/items/items.hooks';
import { useMe } from '@/graphql/user/user.hooks';
import { GraphQLError } from 'graphql';

// Test wrapper that renders hook data into the DOM for assertion
function ItemsHookConsumer({ search }: { search?: string }) {
  const { items, loading, error } = useItems(search);
  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;
  return (
    <ul>
      {items.map((p) => (
        <li key={p.id}>{p.name} - ${p.price}</li>
      ))}
    </ul>
  );
}

function MeHookConsumer() {
  const { user, loading, error } = useMe();
  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;
  if (!user) return <p>Not logged in</p>;
  return <p>{user.displayName} ({user.email})</p>;
}

const mockItems = [
  {
    id: 'uuid-1',
    name: 'Widget',
    slug: 'widget',
    description: 'A test widget',
    price: 19.99,
    category: { id: 'cat-1', name: 'Gadgets' },
    createdAt: '2026-01-01T00:00:00Z',
    updatedAt: '2026-01-01T00:00:00Z',
  },
  {
    id: 'uuid-2',
    name: 'Gizmo',
    slug: 'gizmo',
    description: null,
    price: 49.99,
    category: null,
    createdAt: '2026-01-02T00:00:00Z',
    updatedAt: '2026-01-02T00:00:00Z',
  },
];

const mockUser = {
  id: 'user-1',
  email: 'admin@boilerworks.dev',
  firstName: 'Admin',
  lastName: 'User',
  displayName: 'Admin User',
  permissions: ['*'],
};

describe('useItems hook', () => {
  it('returns items from a mocked GraphQL response', async () => {
    const mocks = [
      {
        request: { query: GET_ITEMS, variables: { search: undefined, categoryId: undefined } },
        result: { data: { items: mockItems } },
      },
    ];

    render(
      <MockedProvider mocks={mocks} addTypename={false}>
        <ItemsHookConsumer />
      </MockedProvider>,
    );

    expect(screen.getByText('Loading...')).toBeDefined();

    await waitFor(() => {
      expect(screen.getByText('Widget - $19.99')).toBeDefined();
      expect(screen.getByText('Gizmo - $49.99')).toBeDefined();
    });
  });

  it('returns an error when the query fails', async () => {
    const mocks = [
      {
        request: { query: GET_ITEMS, variables: { search: undefined, categoryId: undefined } },
        error: new Error('Network failure'),
      },
    ];

    render(
      <MockedProvider mocks={mocks} addTypename={false}>
        <ItemsHookConsumer />
      </MockedProvider>,
    );

    await waitFor(() => {
      expect(screen.getByText(/Error:/)).toBeDefined();
    });
  });

  it('returns empty array when no items exist', async () => {
    const mocks = [
      {
        request: { query: GET_ITEMS, variables: { search: undefined, categoryId: undefined } },
        result: { data: { items: [] } },
      },
    ];

    render(
      <MockedProvider mocks={mocks} addTypename={false}>
        <ItemsHookConsumer />
      </MockedProvider>,
    );

    await waitFor(() => {
      // No list items rendered
      expect(screen.queryByRole('listitem')).toBeNull();
    });
  });
});

describe('useMe hook', () => {
  it('returns user data from a mocked GraphQL response', async () => {
    const mocks = [
      {
        request: { query: GET_ME },
        result: { data: { me: mockUser } },
      },
    ];

    render(
      <MockedProvider mocks={mocks} addTypename={false}>
        <MeHookConsumer />
      </MockedProvider>,
    );

    await waitFor(() => {
      expect(screen.getByText('Admin User (admin@boilerworks.dev)')).toBeDefined();
    });
  });

  it('shows not-logged-in state when me returns null', async () => {
    const mocks = [
      {
        request: { query: GET_ME },
        result: { data: { me: null } },
      },
    ];

    render(
      <MockedProvider mocks={mocks} addTypename={false}>
        <MeHookConsumer />
      </MockedProvider>,
    );

    await waitFor(() => {
      expect(screen.getByText('Not logged in')).toBeDefined();
    });
  });
});
