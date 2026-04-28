import React from 'react';
import { useAuth } from '@/auth/AuthProvider';
import TenantSwitcher from './TenantSwitcher';

export default function TenantBadge() {
    const { user } = useAuth();

    if (!user || !user.roles?.includes('global_admin')) return null;

    return <TenantSwitcher />;
}
