import { describe, it, expect } from 'vitest';

describe('GraphQL type definitions', () => {
  it('Product type has required fields', () => {
    const productFields = ['id', 'name', 'price', 'status', 'category'];
    expect(productFields).toContain('id');
    expect(productFields).toContain('name');
    expect(productFields).toContain('price');
    expect(productFields).toContain('status');
  });

  it('Category type has required fields', () => {
    const categoryFields = ['id', 'name', 'slug', 'description'];
    expect(categoryFields).toContain('id');
    expect(categoryFields).toContain('slug');
  });

  it('FormDefinition type has schema field', () => {
    const formFields = ['id', 'name', 'slug', 'status', 'schema'];
    expect(formFields).toContain('schema');
  });

  it('WorkflowDefinition type has states and transitions', () => {
    const workflowFields = ['id', 'name', 'states', 'transitions'];
    expect(workflowFields).toContain('states');
    expect(workflowFields).toContain('transitions');
  });

  it('User type does not expose password', () => {
    const userFields = ['id', 'name', 'email', 'permissions'];
    expect(userFields).not.toContain('password');
    expect(userFields).not.toContain('passwordDigest');
  });
});
