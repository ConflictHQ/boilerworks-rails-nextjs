import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen } from '@testing-library/react';
import React from 'react';

/**
 * GraphQLErrorBoundary: catches rendering errors and displays
 * a user-friendly message. Mirrors the error-boundary pattern
 * used in the app to handle GraphQL/network failures.
 */
class GraphQLErrorBoundary extends React.Component<
  { children: React.ReactNode; fallbackMessage?: string },
  { hasError: boolean; errorMessage: string | null }
> {
  constructor(props: { children: React.ReactNode; fallbackMessage?: string }) {
    super(props);
    this.state = { hasError: false, errorMessage: null };
  }

  static getDerivedStateFromError(error: Error) {
    return { hasError: true, errorMessage: error.message };
  }

  render() {
    if (this.state.hasError) {
      return (
        <div role="alert">
          <h2>Something went wrong</h2>
          <p>{this.props.fallbackMessage ?? this.state.errorMessage}</p>
        </div>
      );
    }
    return this.props.children;
  }
}

// Component that throws on render -- simulates a GraphQL error in a child
function ThrowingComponent({ message }: { message: string }): React.ReactNode {
  throw new Error(message);
}

function GoodComponent() {
  return <p>All good</p>;
}

describe('GraphQLErrorBoundary', () => {
  // Suppress React's noisy console.error for expected errors
  beforeEach(() => {
    vi.spyOn(console, 'error').mockImplementation(() => {});
  });

  it('renders children when no error occurs', () => {
    render(
      <GraphQLErrorBoundary>
        <GoodComponent />
      </GraphQLErrorBoundary>,
    );
    expect(screen.getByText('All good')).toBeDefined();
  });

  it('renders error message when a child throws', () => {
    render(
      <GraphQLErrorBoundary>
        <ThrowingComponent message="UNAUTHENTICATED" />
      </GraphQLErrorBoundary>,
    );
    expect(screen.getByRole('alert')).toBeDefined();
    expect(screen.getByText('Something went wrong')).toBeDefined();
    expect(screen.getByText('UNAUTHENTICATED')).toBeDefined();
  });

  it('renders custom fallback message when provided', () => {
    render(
      <GraphQLErrorBoundary fallbackMessage="Please try again later">
        <ThrowingComponent message="Network failure" />
      </GraphQLErrorBoundary>,
    );
    expect(screen.getByText('Please try again later')).toBeDefined();
    expect(screen.queryByText('Network failure')).toBeNull();
  });

  it('catches errors from deeply nested children', () => {
    render(
      <GraphQLErrorBoundary>
        <div>
          <div>
            <ThrowingComponent message="Deep error" />
          </div>
        </div>
      </GraphQLErrorBoundary>,
    );
    expect(screen.getByText('Something went wrong')).toBeDefined();
    expect(screen.getByText('Deep error')).toBeDefined();
  });
});
