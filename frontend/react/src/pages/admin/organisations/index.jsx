import { useState, useEffect, useMemo } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthProvider';
import Layout from '@/components/layout/Layout';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

const IconSearch = () => (
    <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
        <circle cx="5.5" cy="5.5" r="3.8" stroke="currentColor" strokeWidth="1.5"/>
        <path d="M8.5 8.5L11 11" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
);

const IconDownload = () => (
    <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
        <path d="M6 1.5v6M3 5.5l3 3.5 3-3.5M1.5 10.5h9" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
);

const IconTrash = () => (
    <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
        <path d="M1.5 3h9M4.5 3V2a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1v1M3 3v7a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1V3M5 6v3M7 6v3" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
);

const IconChevronUp = () => (
    <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
        <path d="M2.5 8.5l4-4.5 4 4.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
);

const calculateMetrics = (orgs) => {
    const now = new Date();
    const dayAgo = new Date(now - 24 * 60 * 60 * 1000);
    const weekAgo = new Date(now - 7 * 24 * 60 * 60 * 1000);
    const hourAgo = new Date(now - 60 * 60 * 1000);
    const thirtyDaysAgo = new Date(now - 30 * 24 * 60 * 60 * 1000);
    const sixtyDaysAgo = new Date(now - 60 * 24 * 60 * 60 * 1000);

    const hourlySignups = orgs.filter(o => new Date(o.createdAt) > hourAgo).length;
    const dailySignups = orgs.filter(o => new Date(o.createdAt) > dayAgo).length;
    const weeklySignups = orgs.filter(o => new Date(o.createdAt) > weekAgo).length;
    const activeOrgs = orgs.filter(o => {
        const lastActivity = o.users
            .filter(u => u.lastLogin)
            .map(u => new Date(u.lastLogin))
            .sort((a, b) => b - a)[0];
        return lastActivity && lastActivity > sixtyDaysAgo;
    }).length;
    const abandonedOrgs = orgs.filter(o => {
        const created = new Date(o.createdAt);
        const hasNoUsers = o.users.length === 0;
        const allUsersInactive = o.users.length > 0 && o.users.every(u => {
            const lastLogin = new Date(u.lastLogin || 0);
            return lastLogin < sixtyDaysAgo;
        });
        return created < thirtyDaysAgo && (hasNoUsers || allUsersInactive);
    }).length;

    return { hourlySignups, dailySignups, weeklySignups, activeOrgs, abandonedOrgs };
};

const getOrgStatus = (org) => {
    const now = new Date();
    const created = new Date(org.createdAt);
    const thirtyDaysAgo = new Date(now - 30 * 24 * 60 * 60 * 1000);
    const sixtyDaysAgo = new Date(now - 60 * 24 * 60 * 60 * 1000);

    if (created > thirtyDaysAgo && org.users.length > 0) return 'new';
    if (org.users.length === 0 && created < thirtyDaysAgo) return 'abandoned';

    const lastActivity = org.users
        .filter(u => u.lastLogin)
        .map(u => new Date(u.lastLogin))
        .sort((a, b) => b - a)[0];

    if (!lastActivity) return 'abandoned';
    if (lastActivity > sixtyDaysAgo) return 'active';
    return 'inactive';
};

export default function AdminOrganisationsIndex() {
    const { user } = useAuth();
    const isGlobalAdmin = user?.roles?.includes('global_admin');

    const [orgs, setOrgs] = useState(null);
    const [error, setError] = useState(null);
    const [search, setSearch] = useState('');
    const [statusFilter, setStatusFilter] = useState('all');
    const [currentPage, setCurrentPage] = useState(1);
    const [deleteConfirm, setDeleteConfirm] = useState(null);
    const itemsPerPage = 20;

    if (user && !isGlobalAdmin) return <Navigate to="/" replace />;

    useEffect(() => {
        fetchWithAuth('/.rest/accounts/admin/organisations-overview')
            .then(r => r?.ok ? r.json() : Promise.reject())
            .then(setOrgs)
            .catch(() => setError('Failed to load organisations'));
    }, []);

    const filtered = useMemo(() => {
        if (!orgs) return [];
        let result = orgs;

        const q = search.toLowerCase().trim();
        if (q) {
            result = result.filter(o =>
                o.orgName.toLowerCase().includes(q) || o.orgSlug.toLowerCase().includes(q)
            );
        }

        if (statusFilter !== 'all') {
            result = result.filter(o => getOrgStatus(o) === statusFilter);
        }

        return result;
    }, [orgs, search, statusFilter]);

    const paged = useMemo(() => {
        const start = (currentPage - 1) * itemsPerPage;
        return filtered.slice(start, start + itemsPerPage);
    }, [filtered, currentPage]);

    const totalPages = Math.ceil(filtered.length / itemsPerPage);
    const metrics = orgs ? calculateMetrics(orgs) : null;

    const handleDeleteOrg = async (orgId) => {
        try {
            const response = await fetchWithAuth(`/.rest/accounts/admin/organisations/${orgId}`, {
                method: 'DELETE'
            });
            if (response?.ok) {
                setOrgs(orgs.filter(o => o.orgId !== orgId));
                setDeleteConfirm(null);
            } else {
                alert('Failed to delete organisation');
            }
        } catch (err) {
            alert('Error deleting organisation: ' + err.message);
        }
    };

    const handleCsvExport = () => {
        if (!orgs) return;
        const rows = [
            ['Org Name', 'Slug', 'Status', 'Created', 'User Count', 'Last Activity'],
            ...filtered.map(o => {
                const lastActivity = o.users
                    .filter(u => u.lastLogin)
                    .map(u => new Date(u.lastLogin))
                    .sort((a, b) => b - a)[0];
                return [
                    o.orgName,
                    o.orgSlug,
                    getOrgStatus(o),
                    new Date(o.createdAt).toLocaleDateString(),
                    o.users.length,
                    lastActivity ? new Date(lastActivity).toLocaleDateString() : 'Never'
                ];
            })
        ];
        const csv = rows.map(r => r.map(v => `"${v}"`).join(',')).join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'organisations-overview.csv';
        a.click();
        URL.revokeObjectURL(url);
    };

    return (
        <>
            <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=Outfit:wght@600;700;800&display=swap" rel="stylesheet" />
            <style>{`
                * { box-sizing: border-box; }
                .dashboard-card {
                    background: linear-gradient(135deg, #f8f9fa 0%, #f5f7fa 100%);
                    border: 1px solid #d1e7f0;
                    border-radius: 12px;
                    padding: 20px;
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                    animation: sl-fade-up 0.4s ease-out both;
                }
                .dashboard-card.alert { border-color: #fccaca; background: linear-gradient(135deg, #fff5f5 0%, #fef2f2 100%); }
                .dashboard-label {
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 11px;
                    font-weight: 600;
                    letter-spacing: 0.08em;
                    text-transform: uppercase;
                    color: #6b7280;
                }
                .dashboard-value {
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 32px;
                    font-weight: 600;
                    color: #0891b2;
                    line-height: 1;
                }
                .dashboard-card.alert .dashboard-value {
                    color: #dc2626;
                }
                .dashboard-secondary {
                    font-size: 12px;
                    color: #9ca3af;
                    margin-top: 4px;
                }
                .filter-panel {
                    background: #f3f4f6;
                    border: 1px solid #d1d5db;
                    border-radius: 12px;
                    padding: 16px 20px;
                    display: flex;
                    gap: 16px;
                    align-items: center;
                    flex-wrap: wrap;
                    margin: 24px 0;
                }
                .filter-input {
                    position: relative;
                    flex: 1;
                    min-width: 200px;
                }
                .filter-input input {
                    width: 100%;
                    padding: 10px 14px 10px 36px;
                    background: white;
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 13px;
                    color: #1f2937;
                    transition: all 0.2s ease;
                }
                .filter-input input::placeholder { color: #9ca3af; }
                .filter-input input:focus {
                    outline: none;
                    border-color: #0891b2;
                    box-shadow: 0 0 0 2px rgba(8,145,178,0.1);
                    background: white;
                }
                .filter-input-icon {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #9ca3af;
                    pointer-events: none;
                }
                .filter-select {
                    padding: 10px 14px;
                    background: white;
                    border: 1px solid #d1d5db;
                    border-radius: 8px;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 13px;
                    color: #1f2937;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }
                .filter-select:focus {
                    outline: none;
                    border-color: #0891b2;
                    box-shadow: 0 0 0 2px rgba(8,145,178,0.1);
                }
                .filter-select option {
                    background: white;
                    color: #1f2937;
                }
                .action-button {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    padding: 9px 14px;
                    background: #e0f2fe;
                    border: 1px solid #bae6fd;
                    border-radius: 8px;
                    color: #0891b2;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 12px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    white-space: nowrap;
                }
                .action-button:hover:not(:disabled) {
                    background: #cffafe;
                    border-color: #a5f3fc;
                    box-shadow: 0 0 12px rgba(8,145,178,0.15);
                }
                .action-button:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }
                .action-button.delete {
                    background: #fee2e2;
                    border-color: #fecaca;
                    color: #dc2626;
                }
                .action-button.delete:hover:not(:disabled) {
                    background: #fecaca;
                    border-color: #fca5a5;
                    box-shadow: 0 0 12px rgba(220,38,38,0.15);
                }
                .table-container {
                    background: white;
                    border: 1px solid #e5e7eb;
                    border-radius: 12px;
                    overflow: hidden;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    font-family: 'Outfit', sans-serif;
                    font-size: 13px;
                }
                thead {
                    background: #f9fafb;
                    border-bottom: 1px solid #e5e7eb;
                }
                th {
                    padding: 14px 16px;
                    text-align: left;
                    font-weight: 700;
                    color: #6b7280;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 11px;
                    letter-spacing: 0.08em;
                    text-transform: uppercase;
                    border-right: 1px solid #e5e7eb;
                }
                th:last-child { border-right: none; }
                tbody tr {
                    border-bottom: 1px solid #f3f4f6;
                    transition: background 0.15s ease;
                }
                tbody tr:hover {
                    background: #f0f9ff;
                }
                tbody tr:last-child {
                    border-bottom: none;
                }
                td {
                    padding: 14px 16px;
                    color: #1f2937;
                    border-right: 1px solid #f3f4f6;
                }
                td:last-child { border-right: none; }
                .status-badge {
                    display: inline-block;
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 11px;
                    font-weight: 600;
                    letter-spacing: 0.05em;
                }
                .status-active {
                    background: #dcfce7;
                    color: #16a34a;
                }
                .status-new {
                    background: #dbeafe;
                    color: #1d4ed8;
                }
                .status-inactive {
                    background: #f3f4f6;
                    color: #6b7280;
                }
                .status-abandoned {
                    background: #fee2e2;
                    color: #dc2626;
                }
                .pagination {
                    display: flex;
                    gap: 8px;
                    justify-content: center;
                    padding: 20px;
                    border-top: 1px solid #e5e7eb;
                    background: #f9fafb;
                }
                .pagination button {
                    padding: 8px 12px;
                    background: #e0f2fe;
                    border: 1px solid #bae6fd;
                    border-radius: 6px;
                    color: #0891b2;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 12px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }
                .pagination button:hover:not(:disabled) {
                    background: #cffafe;
                    border-color: #a5f3fc;
                }
                .pagination button:disabled {
                    opacity: 0.4;
                    cursor: not-allowed;
                }
                .pagination button.active {
                    background: #0891b2;
                    color: white;
                    border-color: #0891b2;
                }
                .modal-overlay {
                    position: fixed;
                    inset: 0;
                    background: rgba(0,0,0,0.7);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                    animation: sl-fade-up 0.2s ease-out;
                }
                .modal {
                    background: white;
                    border: 1px solid #e5e7eb;
                    border-radius: 16px;
                    padding: 24px;
                    max-width: 400px;
                    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                }
                .modal h3 {
                    font-family: 'Outfit', sans-serif;
                    font-size: 18px;
                    font-weight: 700;
                    margin: 0 0 12px;
                    color: #dc2626;
                }
                .modal p {
                    font-size: 14px;
                    color: #6b7280;
                    margin: 0 0 20px;
                    line-height: 1.5;
                }
                .modal-actions {
                    display: flex;
                    gap: 12px;
                    justify-content: flex-end;
                }
                .modal-actions button {
                    padding: 10px 18px;
                    border-radius: 8px;
                    border: 1px solid;
                    font-family: 'IBM Plex Mono', monospace;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s ease;
                }
                .modal-actions .cancel {
                    background: transparent;
                    border-color: #d1d5db;
                    color: #6b7280;
                }
                .modal-actions .cancel:hover {
                    background: #f3f4f6;
                    border-color: #d1d5db;
                }
                .modal-actions .confirm {
                    background: #dc2626;
                    border-color: #dc2626;
                    color: white;
                }
                .modal-actions .confirm:hover {
                    background: #b91c1c;
                    border-color: #b91c1c;
                    box-shadow: 0 0 12px rgba(220,38,38,0.3);
                }
                .empty-state {
                    text-align: center;
                    padding: 60px 40px;
                    color: #9ca3af;
                }
                .empty-state p {
                    font-size: 14px;
                    margin: 0;
                }
            `}</style>
            <Layout
                pagetitle="Org Overview"
                headerTitle="Organisations Overview"
                headerActions={
                    <button
                        onClick={handleCsvExport}
                        disabled={!orgs}
                        className="action-button"
                        style={{ marginRight: 0 }}
                    >
                        <IconDownload /> Export CSV
                    </button>
                }
            >
                <div style={{ padding: '24px 28px 40px' }}>
                    {error && (
                        <div style={{
                            background: '#fee2e2',
                            border: '1px solid #fecaca',
                            color: '#dc2626',
                            padding: '14px 16px',
                            borderRadius: 12,
                            marginBottom: 24,
                            fontSize: 14,
                        }}>
                            {error}
                        </div>
                    )}

                    {/* Dashboard */}
                    {metrics && (
                        <div style={{
                            display: 'grid',
                            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
                            gap: 14,
                            marginBottom: 24,
                        }}>
                            <div className="dashboard-card">
                                <div className="dashboard-label">Hourly Signups</div>
                                <div className="dashboard-value">{metrics.hourlySignups}</div>
                                <div className="dashboard-secondary">Last 60 minutes</div>
                            </div>
                            <div className="dashboard-card">
                                <div className="dashboard-label">Daily Signups</div>
                                <div className="dashboard-value">{metrics.dailySignups}</div>
                                <div className="dashboard-secondary">Last 24 hours</div>
                            </div>
                            <div className="dashboard-card">
                                <div className="dashboard-label">Weekly Signups</div>
                                <div className="dashboard-value">{metrics.weeklySignups}</div>
                                <div className="dashboard-secondary">Last 7 days</div>
                            </div>
                            <div className="dashboard-card">
                                <div className="dashboard-label">Active Orgs</div>
                                <div className="dashboard-value">{metrics.activeOrgs}</div>
                                <div className="dashboard-secondary">Activity in 60 days</div>
                            </div>
                            <div className={`dashboard-card ${metrics.abandonedOrgs > 0 ? 'alert' : ''}`}>
                                <div className="dashboard-label">Abandoned Orgs</div>
                                <div className="dashboard-value">{metrics.abandonedOrgs}</div>
                                <div className="dashboard-secondary">30+ days, no activity</div>
                            </div>
                            <div className="dashboard-card">
                                <div className="dashboard-label">Total Orgs</div>
                                <div className="dashboard-value">{orgs.length}</div>
                                <div className="dashboard-secondary">All time</div>
                            </div>
                        </div>
                    )}

                    {/* Loading */}
                    {!orgs ? (
                        <div style={{
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'center',
                            justifyContent: 'center',
                            padding: '80px 0',
                            gap: 12,
                        }}>
                            <div style={{ display: 'flex', gap: 7, alignItems: 'center' }}>
                                {[0, 150, 300].map(d => (
                                    <span key={d} style={{
                                        width: 7,
                                        height: 7,
                                        borderRadius: '50%',
                                        background: '#0891b2',
                                        animation: 'sl-loading-dot 1.1s ease-in-out infinite',
                                        animationDelay: `${d}ms`,
                                    }}/>
                                ))}
                            </div>
                            <span style={{ fontSize: 13, color: '#6b7280' }}>
                                Loading organisations…
                            </span>
                        </div>
                    ) : (
                        <>
                            {/* Filter Panel */}
                            <div className="filter-panel">
                                <div className="filter-input">
                                    <div className="filter-input-icon"><IconSearch /></div>
                                    <input
                                        type="text"
                                        placeholder="Search by name or slug…"
                                        value={search}
                                        onChange={(e) => {
                                            setSearch(e.target.value);
                                            setCurrentPage(1);
                                        }}
                                    />
                                </div>
                                <select
                                    value={statusFilter}
                                    onChange={(e) => {
                                        setStatusFilter(e.target.value);
                                        setCurrentPage(1);
                                    }}
                                    className="filter-select"
                                >
                                    <option value="all">All Statuses</option>
                                    <option value="active">Active</option>
                                    <option value="new">New</option>
                                    <option value="inactive">Inactive</option>
                                    <option value="abandoned">Abandoned</option>
                                </select>
                                <span style={{
                                    fontSize: 12,
                                    color: '#6b7280',
                                    marginLeft: 'auto',
                                }}>
                                    {filtered.length} of {orgs.length} organisations
                                </span>
                            </div>

                            {/* Table */}
                            {filtered.length === 0 ? (
                                <div className="table-container">
                                    <div className="empty-state">
                                        <p>No organisations found</p>
                                    </div>
                                </div>
                            ) : (
                                <div className="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th style={{ minWidth: 180 }}>Name</th>
                                                <th>Status</th>
                                                <th>Users</th>
                                                <th>Created</th>
                                                <th>Last Activity</th>
                                                <th style={{ textAlign: 'right' }}>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {paged.map(org => {
                                                const status = getOrgStatus(org);
                                                const lastActivity = org.users
                                                    .filter(u => u.lastLogin)
                                                    .map(u => new Date(u.lastLogin))
                                                    .sort((a, b) => b - a)[0];
                                                const createdDate = new Date(org.createdAt);

                                                return (
                                                    <tr key={org.orgId}>
                                                        <td>
                                                            <div style={{ fontWeight: 600, color: '#1f2937' }}>{org.orgName}</div>
                                                            <div style={{
                                                                fontSize: 11,
                                                                color: '#9ca3af',
                                                                fontFamily: "'IBM Plex Mono', monospace",
                                                                marginTop: 2,
                                                            }}>
                                                                {org.orgSlug}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span className={`status-badge status-${status}`}>
                                                                {status.charAt(0).toUpperCase() + status.slice(1)}
                                                            </span>
                                                        </td>
                                                        <td style={{ textAlign: 'center' }}>
                                                            {org.users.length}
                                                        </td>
                                                        <td style={{
                                                            fontSize: 12,
                                                            color: '#6b7280',
                                                            fontFamily: "'IBM Plex Mono', monospace",
                                                        }}>
                                                            {createdDate.toLocaleDateString('en-US', {
                                                                month: 'short',
                                                                day: 'numeric',
                                                                year: '2-digit'
                                                            })}
                                                        </td>
                                                        <td style={{
                                                            fontSize: 12,
                                                            color: '#6b7280',
                                                            fontFamily: "'IBM Plex Mono', monospace",
                                                        }}>
                                                            {lastActivity
                                                                ? lastActivity.toLocaleDateString('en-US', {
                                                                    month: 'short',
                                                                    day: 'numeric',
                                                                    year: '2-digit'
                                                                })
                                                                : '—'
                                                            }
                                                        </td>
                                                        <td style={{ textAlign: 'right' }}>
                                                            <button
                                                                className="action-button delete"
                                                                onClick={() => setDeleteConfirm(org.orgId)}
                                                                title="Delete organisation"
                                                            >
                                                                <IconTrash /> Delete
                                                            </button>
                                                        </td>
                                                    </tr>
                                                );
                                            })}
                                        </tbody>
                                    </table>

                                    {/* Pagination */}
                                    {totalPages > 1 && (
                                        <div className="pagination">
                                            <button
                                                disabled={currentPage === 1}
                                                onClick={() => setCurrentPage(1)}
                                                title="First page"
                                            >
                                                ⟨⟨
                                            </button>
                                            <button
                                                disabled={currentPage === 1}
                                                onClick={() => setCurrentPage(p => p - 1)}
                                                title="Previous page"
                                            >
                                                ⟨
                                            </button>
                                            {Array.from({ length: Math.min(7, totalPages) }, (_, i) => {
                                                const offset = Math.max(0, Math.min(currentPage - 4, totalPages - 7));
                                                return offset + i + 1;
                                            }).map(page => (
                                                <button
                                                    key={page}
                                                    className={currentPage === page ? 'active' : ''}
                                                    onClick={() => setCurrentPage(page)}
                                                >
                                                    {page}
                                                </button>
                                            ))}
                                            <button
                                                disabled={currentPage === totalPages}
                                                onClick={() => setCurrentPage(p => p + 1)}
                                                title="Next page"
                                            >
                                                ⟩
                                            </button>
                                            <button
                                                disabled={currentPage === totalPages}
                                                onClick={() => setCurrentPage(totalPages)}
                                                title="Last page"
                                            >
                                                ⟩⟩
                                            </button>
                                        </div>
                                    )}
                                </div>
                            )}
                        </>
                    )}
                </div>

                {/* Delete Confirmation Modal */}
                {deleteConfirm && (
                    <div className="modal-overlay" onClick={() => setDeleteConfirm(null)}>
                        <div className="modal" onClick={e => e.stopPropagation()}>
                            <h3>Delete Organisation</h3>
                            <p>
                                This will permanently delete this organisation and all associated data. This action cannot be undone.
                            </p>
                            <div className="modal-actions">
                                <button
                                    className="cancel"
                                    onClick={() => setDeleteConfirm(null)}
                                >
                                    Cancel
                                </button>
                                <button
                                    className="confirm"
                                    onClick={() => handleDeleteOrg(deleteConfirm)}
                                >
                                    Delete Permanently
                                </button>
                            </div>
                        </div>
                    </div>
                )}
            </Layout>
        </>
    );
}
