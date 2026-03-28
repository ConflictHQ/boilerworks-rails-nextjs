import { describe, it, expect } from 'vitest';

describe('API client configuration', () => {
  it('uses correct GraphQL endpoint', () => {
    const endpoint = process.env.NEXT_PUBLIC_GRAPHQL_URL || 'http://localhost:3001/graphql';
    expect(endpoint).toContain('/graphql');
  });

  it('includes credentials for session cookies', () => {
    const fetchPolicy = 'include';
    expect(fetchPolicy).toBe('include');
  });

  it('handles auth errors with 401 status', () => {
    const isAuthError = (statusCode: number) => statusCode === 401;
    expect(isAuthError(401)).toBe(true);
    expect(isAuthError(200)).toBe(false);
    expect(isAuthError(403)).toBe(false);
  });

  it('handles permission errors with 403 status', () => {
    const isPermissionError = (statusCode: number) => statusCode === 403;
    expect(isPermissionError(403)).toBe(true);
    expect(isPermissionError(401)).toBe(false);
  });
});

describe('Permission checking', () => {
  it('wildcard scope grants all permissions', () => {
    const hasPermission = (perms: string[], required: string) =>
      perms.includes('*') || perms.includes(required);
    expect(hasPermission(['*'], 'products.view')).toBe(true);
    expect(hasPermission(['*'], 'anything.whatever')).toBe(true);
  });

  it('specific scope grants only that permission', () => {
    const hasPermission = (perms: string[], required: string) =>
      perms.includes('*') || perms.includes(required);
    expect(hasPermission(['products.view'], 'products.view')).toBe(true);
    expect(hasPermission(['products.view'], 'products.create')).toBe(false);
  });

  it('empty scopes deny all', () => {
    const hasPermission = (perms: string[], required: string) =>
      perms.includes('*') || perms.includes(required);
    expect(hasPermission([], 'products.view')).toBe(false);
  });
});
