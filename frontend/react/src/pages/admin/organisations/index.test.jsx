import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { BrowserRouter } from 'react-router-dom';
import { ToastProvider } from '@/components/atoms/Toasts';
import AdminOrganisationsIndex from './index';

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
    const actual = await vi.importActual('react-router-dom');
    return {
        ...actual,
        useNavigate: () => mockNavigate,
    };
});

vi.mock('@/auth/AuthProvider', () => ({
    useAuth: vi.fn(),
    AuthProvider: ({ children }) => children,
}));

vi.mock('@/auth/TenantOverrideContext', () => ({
    TenantOverrideProvider: ({ children }) => children,
    useTenantOverride: vi.fn(() => ({
        tenantOverride: null,
        setTenantOverride: vi.fn(),
    })),
}));

vi.mock('@/utils/fetchWithAuth', () => ({
    fetchWithAuth: vi.fn(),
}));

import { useAuth } from '@/auth/AuthProvider';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

const renderPage = () => {
    return render(
        <BrowserRouter>
            <ToastProvider>
                <AdminOrganisationsIndex />
            </ToastProvider>
        </BrowserRouter>
    );
};

const mockOrgData = [
    {
        orgId: '00000000-0000-0000-0000-000000000001',
        orgName: 'Acme Corp',
        orgSlug: 'acme',
        createdAt: '2026-04-01T10:00:00',
        users: [
            {
                userId: 'user-1',
                email: 'alice@acme.com',
                firstName: 'Alice',
                lastName: 'Smith',
                emailVerified: true,
                roles: ['tenant_admin'],
                lastLogin: '2026-04-25T14:30:00'
            }
        ]
    },
    {
        orgId: '00000000-0000-0000-0000-000000000002',
        orgName: 'Widget Inc',
        orgSlug: 'widget',
        createdAt: '2026-04-02T11:00:00',
        users: [
            {
                userId: 'user-2',
                email: 'bob@widget.com',
                firstName: 'Bob',
                lastName: 'Jones',
                emailVerified: true,
                roles: [],
                lastLogin: null
            }
        ]
    }
];

describe('AdminOrganisationsIndex', () => {
    beforeEach(() => {
        vi.clearAllMocks();
        global.fetch = vi.fn();
    });

    it('non-admin redirects to /', () => {
        useAuth.mockReturnValue({
            user: { roles: ['tenant_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        renderPage();
        // Navigate component redirects, so table should not be rendered
        expect(screen.queryByText('Org Name')).not.toBeInTheDocument();
    });

    it('admin sees org table with data', async () => {
        useAuth.mockReturnValue({
            user: { roles: ['global_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        fetchWithAuth.mockResolvedValue({
            ok: true,
            json: async () => mockOrgData
        });

        renderPage();
        expect(await screen.findByText('Acme Corp')).toBeInTheDocument();
        expect(screen.getByText('Widget Inc')).toBeInTheDocument();
        expect(screen.getByText('acme')).toBeInTheDocument();
    });

    it('row expansion shows user sub-table', async () => {
        const user = userEvent.setup();
        useAuth.mockReturnValue({
            user: { roles: ['global_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        fetchWithAuth.mockResolvedValue({
            ok: true,
            json: async () => mockOrgData
        });

        renderPage();
        const acmeRow = await screen.findByText('Acme Corp');
        await user.click(acmeRow.closest('div[style*="gridTemplateColumns"]')?.parentElement || acmeRow);
        expect(await screen.findByText('alice@acme.com')).toBeInTheDocument();
    });

    it('search filter hides non-matching orgs', async () => {
        const user = userEvent.setup();
        useAuth.mockReturnValue({
            user: { roles: ['global_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        fetchWithAuth.mockResolvedValue({
            ok: true,
            json: async () => mockOrgData
        });

        renderPage();
        await screen.findByText('Acme Corp');
        const searchInput = screen.getByPlaceholderText('Search orgs...');
        await user.type(searchInput, 'widget');
        expect(screen.queryByText('Acme Corp')).not.toBeInTheDocument();
        expect(screen.getByText('Widget Inc')).toBeInTheDocument();
    });

    it('CSV export button is present and clickable', async () => {
        const user = userEvent.setup();
        useAuth.mockReturnValue({
            user: { roles: ['global_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        fetchWithAuth.mockResolvedValue({
            ok: true,
            json: async () => mockOrgData
        });

        renderPage();
        const exportBtn = await screen.findByRole('button', { name: /Export CSV/i });
        expect(exportBtn).toBeInTheDocument();
        expect(exportBtn).not.toBeDisabled();
        await user.click(exportBtn);
        expect(exportBtn).toBeInTheDocument();
    });

    it('null lastLogin renders "Never"', async () => {
        const user = userEvent.setup();
        useAuth.mockReturnValue({
            user: { roles: ['global_admin'], emailVerified: true },
            isAuthenticated: true,
            isLoading: false,
            accessToken: 'token'
        });
        fetchWithAuth.mockResolvedValue({
            ok: true,
            json: async () => mockOrgData
        });

        renderPage();
        const widgetRow = await screen.findByText('Widget Inc');
        await user.click(widgetRow.closest('div[style*="gridTemplateColumns"]')?.parentElement || widgetRow);
        expect(screen.getByText('Never')).toBeInTheDocument();
    });
});
