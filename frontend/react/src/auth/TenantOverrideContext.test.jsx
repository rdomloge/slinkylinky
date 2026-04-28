import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render } from '@testing-library/react';
import { TenantOverrideProvider } from './TenantOverrideContext';

vi.mock('@/auth/AuthProvider', () => ({
    useAuth: vi.fn(),
}));

import { useAuth } from '@/auth/AuthProvider';

function Noop() { return null; }

describe('TenantOverrideProvider', () => {
    beforeEach(() => {
        sessionStorage.clear();
        vi.clearAllMocks();
    });

    it('clears sl_tenant_override for non-global_admin on mount', () => {
        sessionStorage.setItem('sl_tenant_override', 'some-org-id');
        useAuth.mockReturnValue({ user: { roles: ['tenant_admin'] } });

        render(<TenantOverrideProvider><Noop /></TenantOverrideProvider>);

        expect(sessionStorage.getItem('sl_tenant_override')).toBeNull();
    });

    it('preserves sl_tenant_override for global_admin on mount', () => {
        sessionStorage.setItem('sl_tenant_override', 'some-org-id');
        useAuth.mockReturnValue({ user: { roles: ['global_admin'] } });

        render(<TenantOverrideProvider><Noop /></TenantOverrideProvider>);

        expect(sessionStorage.getItem('sl_tenant_override')).toBe('some-org-id');
    });
});
