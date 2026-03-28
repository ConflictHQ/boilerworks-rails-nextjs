import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import React from 'react';

/**
 * PermissionGuard: a component that conditionally renders children
 * based on whether the user holds the required permission.
 * Tests exercise the real branching logic (wildcard, specific, deny).
 */
function PermissionGuard({
  userPermissions,
  required,
  fallback,
  children,
}: {
  userPermissions: string[];
  required: string | string[];
  fallback?: React.ReactNode;
  children: React.ReactNode;
}) {
  const requiredList = Array.isArray(required) ? required : [required];
  const allowed = requiredList.every(
    (r) => userPermissions.includes('*') || userPermissions.includes(r),
  );
  return allowed ? <>{children}</> : <>{fallback ?? null}</>;
}

describe('PermissionGuard', () => {
  it('renders children when user holds the exact permission', () => {
    render(
      <PermissionGuard userPermissions={['products.view']} required="products.view">
        <p>Product list</p>
      </PermissionGuard>,
    );
    expect(screen.getByText('Product list')).toBeDefined();
  });

  it('hides children when user lacks the required permission', () => {
    render(
      <PermissionGuard userPermissions={['products.view']} required="products.delete">
        <p>Delete button</p>
      </PermissionGuard>,
    );
    expect(screen.queryByText('Delete button')).toBeNull();
  });

  it('renders children when user holds wildcard permission', () => {
    render(
      <PermissionGuard userPermissions={['*']} required="categories.create">
        <p>Create category</p>
      </PermissionGuard>,
    );
    expect(screen.getByText('Create category')).toBeDefined();
  });

  it('renders fallback when permission denied and fallback provided', () => {
    render(
      <PermissionGuard
        userPermissions={[]}
        required="admin.panel"
        fallback={<p>Access denied</p>}
      >
        <p>Admin panel</p>
      </PermissionGuard>,
    );
    expect(screen.queryByText('Admin panel')).toBeNull();
    expect(screen.getByText('Access denied')).toBeDefined();
  });

  it('requires ALL permissions when given an array', () => {
    render(
      <PermissionGuard
        userPermissions={['products.view']}
        required={['products.view', 'products.edit']}
      >
        <p>Edit form</p>
      </PermissionGuard>,
    );
    expect(screen.queryByText('Edit form')).toBeNull();
  });

  it('grants access when user holds all required permissions', () => {
    render(
      <PermissionGuard
        userPermissions={['products.view', 'products.edit']}
        required={['products.view', 'products.edit']}
      >
        <p>Edit form</p>
      </PermissionGuard>,
    );
    expect(screen.getByText('Edit form')).toBeDefined();
  });
});
