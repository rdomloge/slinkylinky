import { useState, useEffect, useCallback } from 'react';
import { Navigate } from 'react-router-dom';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';
import { PanelCard } from '@/components/PanelCard';
import Layout from '@/components/layout/Layout';
import { fetchWithAuth } from '@/utils/fetchWithAuth';


const POLL_INTERVAL_MS = 30_000;

const ALLOWED_ROLES = ['tenant_admin', 'global_admin'];

const SERVICE_LABELS = {
    linkservice:        'Link Service',
    stats:              'Stats',
    audit:              'Audit',
    supplierengagement: 'Supplier Engagement',
    userservice:        'User Service',
};

function StatusBadge({ status }) {
    const styles = {
        UP:      { bg: '#dcfce7', color: '#16a34a', label: 'UP' },
        DOWN:    { bg: '#fee2e2', color: '#dc2626', label: 'DOWN' },
        TIMEOUT: { bg: '#fef9c3', color: '#ca8a04', label: 'TIMEOUT' },
        DEGRADED:{ bg: '#ffedd5', color: '#ea580c', label: 'DEGRADED' },
    };
    const s = styles[status] ?? { bg: '#f1f5f9', color: '#94a3b8', label: status ?? '…' };
    return (
        <span className="text-xs font-bold px-2 py-0.5 rounded-full"
              style={{ background: s.bg, color: s.color }}>
            {s.label}
        </span>
    );
}

function ServiceRow({ name, status }) {
    const isUp = status === 'UP';
    return (
        <div className="flex items-center justify-between py-2.5 border-b border-slate-100 last:border-0">
            <div className="flex items-center gap-2">
                <span className={`w-2 h-2 rounded-full shrink-0 ${isUp ? 'bg-green-400' : 'bg-red-400'}`} />
                <span className="text-sm text-slate-700" style={{ fontFamily: "'Outfit', sans-serif" }}>
                    {SERVICE_LABELS[name] ?? name}
                </span>
            </div>
            <StatusBadge status={status} />
        </div>
    );
}

export default function TenantHealthPage() {
    const [services, setServices] = useState([]);
    const [loading, setLoading] = useState(true);
    const [lastUpdated, setLastUpdated] = useState(null);

    const poll = useCallback(async () => {
        try {
            const response = await fetchWithAuth('/.rest/admin/tenant-health');
            if (response && response.ok) {
                const data = await response.json();
                setServices(data);
                setLastUpdated(new Date());
            }
        } catch (e) {
            // keep stale data on error
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        poll();
        const id = setInterval(poll, POLL_INTERVAL_MS);
        return () => clearInterval(id);
    }, [poll]);

    const allUp = services.length > 0 && services.every(s => s.status === 'UP');
    const downCount = services.filter(s => s.status !== 'UP').length;

    return (
        <AuthorizedAccess allowedRoles={ALLOWED_ROLES} unauthorizedContent={<Navigate to="/" replace />}>
            <Layout>
                <div className="space-y-6 max-w-2xl">
                    <div>
                        <h1 className="text-xl font-semibold text-slate-800" style={{ fontFamily: "'Outfit', sans-serif" }}>
                            Tenant Health
                        </h1>
                        <p className="text-sm text-slate-400 mt-1">
                            Live status of all services in this tenant. Refreshes every 30 seconds.
                        </p>
                    </div>

                    {!loading && (
                        <div className="flex items-center gap-3">
                            <span className={`w-3 h-3 rounded-full ${allUp ? 'bg-green-400' : 'bg-red-400'}`} />
                            <span className="text-sm font-medium text-slate-700">
                                {allUp ? 'All services operational' : `${downCount} service${downCount !== 1 ? 's' : ''} degraded`}
                            </span>
                            {lastUpdated && (
                                <span className="text-xs text-slate-400 ml-auto">
                                    Updated {lastUpdated.toLocaleTimeString()}
                                </span>
                            )}
                        </div>
                    )}

                    <PanelCard title="Services" loading={loading} accentColor="#6366f1">
                        {services.map(s => (
                            <ServiceRow key={s.service} name={s.service} status={s.status} />
                        ))}
                        {!loading && services.length === 0 && (
                            <p className="text-sm text-slate-400 py-2">No service data available.</p>
                        )}
                    </PanelCard>
                </div>
            </Layout>
        </AuthorizedAccess>
    );
}
