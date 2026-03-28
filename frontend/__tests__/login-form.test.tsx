import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import React, { useState } from 'react';

/**
 * LoginForm with client-side email validation.
 * Tests cover field rendering, validation, and submit handler invocation.
 */
function LoginForm({
  onSubmit,
}: {
  onSubmit: (email: string, password: string) => void;
}) {
  const [emailError, setEmailError] = useState<string | null>(null);

  const validate = (email: string): boolean => {
    if (!email) {
      setEmailError('Email is required');
      return false;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setEmailError('Invalid email format');
      return false;
    }
    setEmailError(null);
    return true;
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        const form = e.target as HTMLFormElement;
        const email = (form.elements.namedItem('email') as HTMLInputElement).value;
        const password = (form.elements.namedItem('password') as HTMLInputElement).value;
        if (validate(email)) {
          onSubmit(email, password);
        }
      }}
    >
      <label htmlFor="email">Email</label>
      <input id="email" name="email" type="text" aria-describedby="email-error" />
      {emailError && (
        <span id="email-error" role="alert">
          {emailError}
        </span>
      )}
      <label htmlFor="password">Password</label>
      <input id="password" name="password" type="password" />
      <button type="submit">Sign in</button>
    </form>
  );
}

describe('LoginForm', () => {
  it('renders email field, password field, and submit button', () => {
    render(<LoginForm onSubmit={() => {}} />);
    expect(screen.getByLabelText('Email')).toBeDefined();
    expect(screen.getByLabelText('Password')).toBeDefined();
    expect(screen.getByRole('button', { name: 'Sign in' })).toBeDefined();
  });

  it('calls onSubmit with email and password on valid submission', async () => {
    const handleSubmit = vi.fn();
    const user = userEvent.setup();
    render(<LoginForm onSubmit={handleSubmit} />);

    await user.type(screen.getByLabelText('Email'), 'admin@boilerworks.dev');
    await user.type(screen.getByLabelText('Password'), 'password');
    await user.click(screen.getByRole('button', { name: 'Sign in' }));

    expect(handleSubmit).toHaveBeenCalledOnce();
    expect(handleSubmit).toHaveBeenCalledWith('admin@boilerworks.dev', 'password');
  });

  it('shows validation error for invalid email format', async () => {
    const handleSubmit = vi.fn();
    const user = userEvent.setup();
    render(<LoginForm onSubmit={handleSubmit} />);

    await user.type(screen.getByLabelText('Email'), 'not-an-email');
    await user.type(screen.getByLabelText('Password'), 'password');
    await user.click(screen.getByRole('button', { name: 'Sign in' }));

    expect(screen.getByRole('alert')).toBeDefined();
    expect(screen.getByRole('alert').textContent).toBe('Invalid email format');
    expect(handleSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for empty email', async () => {
    const handleSubmit = vi.fn();
    const user = userEvent.setup();
    render(<LoginForm onSubmit={handleSubmit} />);

    await user.click(screen.getByRole('button', { name: 'Sign in' }));

    expect(screen.getByRole('alert').textContent).toBe('Email is required');
    expect(handleSubmit).not.toHaveBeenCalled();
  });

  it('does not show error initially', () => {
    render(<LoginForm onSubmit={() => {}} />);
    expect(screen.queryByRole('alert')).toBeNull();
  });
});
