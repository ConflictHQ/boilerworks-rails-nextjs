import { describe, it, expect } from 'vitest';
import { routeLabels } from '@/lib/routes';
import { cn } from '@/lib/utils';

describe('routeLabels', () => {
  it('maps dashboard to Dashboard', () => {
    expect(routeLabels['dashboard']).toBe('Dashboard');
  });

  it('maps products to Products', () => {
    expect(routeLabels['products']).toBe('Products');
  });

  it('maps forms to Form Engine', () => {
    expect(routeLabels['forms']).toBe('Form Engine');
  });

  it('returns undefined for unknown routes', () => {
    expect(routeLabels['nonexistent']).toBeUndefined();
  });
});

describe('cn utility', () => {
  it('merges class names', () => {
    expect(cn('px-2', 'py-1')).toBe('px-2 py-1');
  });

  it('resolves Tailwind conflicts (last wins)', () => {
    const result = cn('px-2', 'px-4');
    expect(result).toBe('px-4');
  });

  it('handles conditional classes', () => {
    const isActive = true;
    const result = cn('text-sm', isActive && 'font-bold');
    expect(result).toContain('font-bold');
  });

  it('filters falsy values', () => {
    const result = cn('base', false, null, undefined, 'extra');
    expect(result).toBe('base extra');
  });
});
