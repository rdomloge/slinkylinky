import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, fireEvent, waitFor, within } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { BrowserRouter } from 'react-router-dom';
import Register from './index';

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
    const actual = await vi.importActual('react-router-dom');
    return {
        ...actual,
        useNavigate: () => mockNavigate,
    };
});

const renderRegisterPage = () => {
    return render(
        <BrowserRouter>
            <Register />
        </BrowserRouter>
    );
};

describe('Register page', () => {
    beforeEach(() => {
        mockNavigate.mockClear();
        global.fetch = vi.fn();
    });

    describe('page rendering', () => {
        it('renders the registration form with all fields', () => {
            renderRegisterPage();
            expect(screen.getByText('Create an account')).toBeInTheDocument();
            expect(screen.getByLabelText('First name')).toBeInTheDocument();
            expect(screen.getByLabelText('Last name')).toBeInTheDocument();
            expect(screen.getByLabelText('Email address')).toBeInTheDocument();
            expect(screen.getByLabelText('Company name')).toBeInTheDocument();
            expect(screen.getByLabelText('Password')).toBeInTheDocument();
            expect(screen.getByLabelText('Confirm password')).toBeInTheDocument();
            expect(screen.getByRole('button', { name: 'Create account' })).toBeInTheDocument();
        });

        it('displays sign-in link', () => {
            renderRegisterPage();
            const signInLink = screen.getByRole('link', { name: 'Sign in' });
            expect(signInLink).toBeInTheDocument();
            expect(signInLink).toHaveAttribute('href', '/');
        });

        it('shows page description', () => {
            renderRegisterPage();
            expect(
                screen.getByText('Join SlinkyLinky to manage your SEO link building strategy.')
            ).toBeInTheDocument();
        });
    });

    describe('required field validation', () => {
        it('shows error for empty first name', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const submitButton = screen.getByRole('button', { name: 'Create account' });

            await user.click(submitButton);
            expect(await screen.findByText('First name is required')).toBeInTheDocument();
        });

        it('shows error for empty last name', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const firstNameInput = screen.getByLabelText('First name');

            await user.type(firstNameInput, 'John');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Last name is required')).toBeInTheDocument();
        });

        it('shows error for empty email', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const firstNameInput = screen.getByLabelText('First name');
            const lastNameInput = screen.getByLabelText('Last name');

            await user.type(firstNameInput, 'John');
            await user.type(lastNameInput, 'Doe');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Email is required')).toBeInTheDocument();
        });

        it('shows error for empty company name', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const firstNameInput = screen.getByLabelText('First name');
            const lastNameInput = screen.getByLabelText('Last name');
            const emailInput = screen.getByLabelText('Email address');

            await user.type(firstNameInput, 'John');
            await user.type(lastNameInput, 'Doe');
            await user.type(emailInput, 'test@example.com');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Company name is required')).toBeInTheDocument();
        });

        it('shows error for empty password', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const emailInput = screen.getByLabelText('Email address');
            const orgInput = screen.getByLabelText('Company name');

            await user.type(emailInput, 'test@example.com');
            await user.type(orgInput, 'Test Org');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Password is required')).toBeInTheDocument();
        });

        it('shows error for empty password confirm', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const emailInput = screen.getByLabelText('Email address');
            const orgInput = screen.getByLabelText('Company name');
            const passwordInput = screen.getByLabelText('Password');

            await user.type(emailInput, 'test@example.com');
            await user.type(orgInput, 'Test Org');
            await user.type(passwordInput, 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Please confirm your password')).toBeInTheDocument();
        });
    });

    describe('email validation', () => {
        it('shows error for invalid email format', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const emailInput = screen.getByLabelText('Email address');

            await user.type(emailInput, 'invalidemail');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Please enter a valid email address')).toBeInTheDocument();
        });

        it('accepts valid email format', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const emailInput = screen.getByLabelText('Email address');

            await user.clear(emailInput);
            await user.type(emailInput, 'test@example.com');
            expect(screen.queryByText('Please enter a valid email address')).not.toBeInTheDocument();
        });
    });

    describe('password validation', () => {
        it('shows error for password less than 8 characters', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const passwordInput = screen.getByLabelText('Password');

            await user.type(passwordInput, 'short');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Password must be at least 8 characters')).toBeInTheDocument();
        });

        it('accepts password with 8 or more characters', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const passwordInput = screen.getByLabelText('Password');

            await user.type(passwordInput, 'validpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(screen.queryByText('Password must be at least 8 characters')).not.toBeInTheDocument();
        });
    });

    describe('password confirmation', () => {
        it('shows error when passwords do not match', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const passwordInput = screen.getByLabelText('Password');
            const confirmInput = screen.getByLabelText('Confirm password');

            await user.type(passwordInput, 'testpass123');
            await user.type(confirmInput, 'differentpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Passwords do not match')).toBeInTheDocument();
        });

        it('clears error when passwords match', async () => {
            const user = userEvent.setup();
            renderRegisterPage();
            const passwordInput = screen.getByLabelText('Password');
            const confirmInput = screen.getByLabelText('Confirm password');

            await user.type(passwordInput, 'testpass123');
            await user.type(confirmInput, 'differentpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('Passwords do not match')).toBeInTheDocument();

            await user.clear(confirmInput);
            await user.type(confirmInput, 'testpass123');
            expect(screen.queryByText('Passwords do not match')).not.toBeInTheDocument();
        });
    });

    describe('successful registration', () => {
        it('submits valid form and navigates on success', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: true,
                    status: 201,
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            await waitFor(() => {
                expect(mockNavigate).toHaveBeenCalledWith('/?registered=true');
            });
        });

        it('sends correct POST request with form data', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: true,
                    status: 201,
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            await waitFor(() => {
                expect(global.fetch).toHaveBeenCalledWith(
                    '/.rest/accounts/registration',
                    expect.objectContaining({
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            firstName: 'John',
                            lastName: 'Doe',
                            email: 'test@example.com',
                            companyName: 'Test Company',
                            password: 'testpass123',
                        }),
                    })
                );
            });
        });

        it('shows loading spinner during submit', async () => {
            const user = userEvent.setup();
            let resolveResponse;
            const responsePromise = new Promise((resolve) => {
                resolveResponse = resolve;
            });
            global.fetch = vi.fn(() => responsePromise);

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Org');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');

            const submitButton = screen.getByRole('button', { name: 'Create account' });
            await user.click(submitButton);

            expect(screen.getByRole('button')).toBeDisabled();
            expect(submitButton.textContent).not.toContain('Create account');

            resolveResponse({
                ok: true,
                status: 201,
            });
        });
    });

    describe('EMAIL_EXISTS error handling', () => {
        it('shows inline error for duplicate email', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: false,
                    status: 409,
                    json: () => Promise.resolve({ code: 'EMAIL_EXISTS' }),
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'existing@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(
                await screen.findByText('An account with this email already exists')
            ).toBeInTheDocument();
        });

        it('clears EMAIL_EXISTS error when email field is edited', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: false,
                    status: 409,
                    json: () => Promise.resolve({ code: 'EMAIL_EXISTS' }),
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'existing@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(
                await screen.findByText('An account with this email already exists')
            ).toBeInTheDocument();

            const emailInput = screen.getByLabelText('Email address');
            await user.clear(emailInput);
            await user.type(emailInput, 'newemail@example.com');

            expect(
                screen.queryByText('An account with this email already exists')
            ).not.toBeInTheDocument();
        });
    });

    describe('rate limit (429) error handling', () => {
        it('shows inline error for rate limit', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: false,
                    status: 429,
                    json: () => Promise.resolve({}),
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(
                await screen.findByText('Too many registration attempts. Please try again later.')
            ).toBeInTheDocument();
        });

        it('clears rate limit error when form is edited', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() =>
                Promise.resolve({
                    ok: false,
                    status: 429,
                    json: () => Promise.resolve({}),
                })
            );

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(
                await screen.findByText('Too many registration attempts. Please try again later.')
            ).toBeInTheDocument();

            const emailInput = screen.getByLabelText('Email address');
            await user.clear(emailInput);
            await user.type(emailInput, 'test2@example.com');

            expect(
                screen.queryByText('Too many registration attempts. Please try again later.')
            ).not.toBeInTheDocument();
        });
    });

    describe('network error handling', () => {
        it('shows error message on network failure', async () => {
            const user = userEvent.setup();
            global.fetch = vi.fn(() => Promise.reject(new Error('Network error')));

            renderRegisterPage();

            await user.type(screen.getByLabelText('First name'), 'John');
            await user.type(screen.getByLabelText('Last name'), 'Doe');
            await user.type(screen.getByLabelText('Email address'), 'test@example.com');
            await user.type(screen.getByLabelText('Company name'), 'Test Company');
            await user.type(screen.getByLabelText('Password'), 'testpass123');
            await user.type(screen.getByLabelText('Confirm password'), 'testpass123');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(await screen.findByText('An error occurred. Please try again.')).toBeInTheDocument();
        });
    });

    describe('form state management', () => {
        it('preserves form values when not submitted', async () => {
            const user = userEvent.setup();
            renderRegisterPage();

            const firstNameInput = screen.getByLabelText('First name');
            const lastNameInput = screen.getByLabelText('Last name');
            const emailInput = screen.getByLabelText('Email address');
            const companyInput = screen.getByLabelText('Company name');
            const passwordInput = screen.getByLabelText('Password');

            await user.type(firstNameInput, 'John');
            await user.type(lastNameInput, 'Doe');
            await user.type(emailInput, 'test@example.com');
            await user.type(companyInput, 'Test Company');
            await user.type(passwordInput, 'testpass123');

            expect(firstNameInput).toHaveValue('John');
            expect(lastNameInput).toHaveValue('Doe');
            expect(emailInput).toHaveValue('test@example.com');
            expect(companyInput).toHaveValue('Test Company');
            expect(passwordInput).toHaveValue('testpass123');
        });

        it('clears individual field errors when field is edited', async () => {
            const user = userEvent.setup();
            renderRegisterPage();

            const emailInput = screen.getByLabelText('Email address');
            await user.type(emailInput, 'invalidemail');
            await user.click(screen.getByRole('button', { name: 'Create account' }));

            expect(
                await screen.findByText('Please enter a valid email address')
            ).toBeInTheDocument();

            await user.clear(emailInput);
            await user.type(emailInput, 'valid@example.com');

            expect(
                screen.queryByText('Please enter a valid email address')
            ).not.toBeInTheDocument();
        });
    });
});
