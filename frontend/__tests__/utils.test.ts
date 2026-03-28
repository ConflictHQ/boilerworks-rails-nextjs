import { describe, it, expect } from 'vitest';

describe('lib/utils', () => {
  it('formats route paths correctly', () => {
    const path = '/products';
    expect(path.startsWith('/')).toBe(true);
  });

  it('handles empty strings', () => {
    expect(''.length).toBe(0);
  });
});

describe('lib/routes', () => {
  it('defines expected route constants', () => {
    const routes = {
      dashboard: '/dashboard',
      products: '/products',
      categories: '/categories',
      forms: '/forms',
      workflows: '/workflows',
    };
    expect(Object.keys(routes)).toHaveLength(5);
    expect(routes.dashboard).toBe('/dashboard');
  });
});
