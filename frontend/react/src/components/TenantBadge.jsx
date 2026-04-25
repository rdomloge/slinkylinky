import React, { useEffect, useState } from 'react';
import { useAuth } from '@/auth/AuthProvider';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import TenantSwitcher from './TenantSwitcher';

export default function TenantBadge() {
    const { user } = useAuth();
    const [orgName, setOrgName] = useState(null);

    const isGlobalAdmin = user?.roles?.includes('global_admin');

    useEffect(() => {
        if (!user?.orgId || isGlobalAdmin) return;
        fetchWithAuth(`/.rest/accounts/organisations/${user.orgId}`)
            .then(r => r?.ok ? r.json() : null)
            .then(data => { if (data?.name) setOrgName(data.name); })
            .catch(() => {});
    }, [user?.orgId, isGlobalAdmin]);

    if (!user) return null;

    if (isGlobalAdmin) {
        return <TenantSwitcher />;
    }

    return (
        <div className="px-4 py-2 border-b border-white/10 text-xs text-slate-400 truncate">
            <span className="text-slate-500">Org: </span>
            <span className="text-slate-300">{orgName || user.orgId || '—'}</span>
        </div>
    );
}
