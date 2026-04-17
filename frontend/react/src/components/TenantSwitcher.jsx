import React, { useEffect, useState } from 'react';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { useTenantOverride } from '@/auth/TenantOverrideContext';

export default function TenantSwitcher() {
    const [orgs, setOrgs] = useState([]);
    const { overrideOrgId, setOverrideOrgId } = useTenantOverride();

    useEffect(() => {
        fetchWithAuth('/.rest/organisations')
            .then(r => r?.ok ? r.json() : null)
            .then(data => {
                if (data?._embedded?.organisations) {
                    setOrgs(data._embedded.organisations);
                    if (!overrideOrgId && data._embedded.organisations.length > 0) {
                        setOverrideOrgId(data._embedded.organisations[0].id);
                    }
                }
            })
            .catch(() => {});
    }, [overrideOrgId, setOverrideOrgId]);

    const currentOrg = orgs.find(o => o.id === overrideOrgId);

    return (
        <div className="px-3 py-2 border-b border-white/10">
            <div className="text-xs text-slate-500 mb-1">Viewing as tenant</div>
            <select
                value={overrideOrgId || ''}
                onChange={e => setOverrideOrgId(e.target.value || null)}
                className="w-full text-xs bg-white/5 text-slate-300 border border-white/10 rounded px-2 py-1 focus:outline-none focus:border-violet-400"
            >
                {orgs.map(org => (
                    <option key={org.id} value={org.id}>{org.name}</option>
                ))}
            </select>
        </div>
    );
}
