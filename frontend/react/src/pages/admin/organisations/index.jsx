import { useState, useEffect, useMemo } from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '@/auth/AuthProvider';
import Layout from '@/components/layout/Layout';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

const PALETTE = [
    { bg: 'linear-gradient(135deg, #6db89d 0%, #4fa082 100%)', glow: 'rgba(109,184,157,0.22)', accent: '#6db89d', muted: 'rgba(109,184,157,0.10)' },
    { bg: 'linear-gradient(135deg, #a89dbd 0%, #8573a8 100%)', glow: 'rgba(168,157,189,0.22)', accent: '#a89dbd', muted: 'rgba(168,157,189,0.10)' },
    { bg: 'linear-gradient(135deg, #d4a574 0%, #b8864e 100%)', glow: 'rgba(212,165,116,0.22)', accent: '#d4a574', muted: 'rgba(212,165,116,0.10)' },
    { bg: 'linear-gradient(135deg, #5f7f99 0%, #446880 100%)', glow: 'rgba(95,127,153,0.22)',  accent: '#5f7f99', muted: 'rgba(95,127,153,0.10)'  },
    { bg: 'linear-gradient(135deg, #9bb87d 0%, #7a9c58 100%)', glow: 'rgba(155,184,125,0.22)', accent: '#9bb87d', muted: 'rgba(155,184,125,0.10)' },
];

const pick = (name) => PALETTE[name.charCodeAt(0) % PALETTE.length];

const IconUsers = () => (
    <svg width="11" height="11" viewBox="0 0 11 11" fill="none">
        <circle cx="4" cy="3.5" r="1.8" stroke="currentColor" strokeWidth="1.4"/>
        <path d="M0.5 9.5c0-1.93 1.57-3.5 3.5-3.5s3.5 1.57 3.5 3.5" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
        <circle cx="8.5" cy="3.5" r="1.3" stroke="currentColor" strokeWidth="1.3"/>
        <path d="M10.5 9.5c0-1.38-.9-2.56-2.15-2.95" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
    </svg>
);

const IconCal = () => (
    <svg width="11" height="11" viewBox="0 0 11 11" fill="none">
        <rect x="1" y="2" width="9" height="8" rx="1.5" stroke="currentColor" strokeWidth="1.4"/>
        <path d="M3.5 1v2M7.5 1v2M1 5h9" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/>
    </svg>
);

const IconPulse = () => (
    <svg width="9" height="9" viewBox="0 0 9 9" fill="none">
        <circle cx="4.5" cy="4.5" r="3" fill="currentColor" opacity="0.8"/>
    </svg>
);

const IconChevron = () => (
    <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
        <path d="M2.5 4.5l4 4.5 4-4.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
);

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

export default function AdminOrganisationsIndex() {
    const { user } = useAuth();
    const isGlobalAdmin = user?.roles?.includes('global_admin');

    const [orgs, setOrgs] = useState(null);
    const [error, setError] = useState(null);
    const [search, setSearch] = useState('');
    const [expandedOrgId, setExpandedOrgId] = useState(null);

    if (user && !isGlobalAdmin) return <Navigate to="/" replace />;

    useEffect(() => {
        fetchWithAuth('/.rest/accounts/admin/organisations-overview')
            .then(r => r?.ok ? r.json() : Promise.reject())
            .then(setOrgs)
            .catch(() => setError('Failed to load organisations'));
    }, []);

    const filtered = useMemo(() => {
        if (!orgs) return [];
        const q = search.toLowerCase().trim();
        if (!q) return orgs;
        return orgs.filter(o =>
            o.orgName.toLowerCase().includes(q) || o.orgSlug.toLowerCase().includes(q)
        );
    }, [orgs, search]);

    const handleCsvExport = () => {
        if (!orgs) return;
        const rows = [
            ['Org Name', 'Slug', 'Created', 'User Email', 'Roles', 'Last Login'],
            ...orgs.flatMap(o =>
                o.users.length === 0
                    ? [[o.orgName, o.orgSlug, o.createdAt, '', '', '']]
                    : o.users.map(u => [
                        o.orgName, o.orgSlug, o.createdAt, u.email,
                        u.roles.join(';'),
                        u.lastLogin ? new Date(u.lastLogin).toLocaleString() : 'Never'
                    ])
            )
        ];
        const csv = rows.map(r => r.map(v => `"${v}"`).join(',')).join('\n');
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url; a.download = 'organisations-overview.csv'; a.click();
        URL.revokeObjectURL(url);
    };

    const totalUsers = orgs?.reduce((sum, o) => sum + o.users.length, 0) ?? 0;

    return (
        <>
            <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&display=swap" rel="stylesheet" />
            <style>{`
                .org-card {
                    background: white;
                    border: 1px solid var(--border-light);
                    border-radius: 18px;
                    overflow: hidden;
                    cursor: pointer;
                    transition: box-shadow 0.25s ease, transform 0.22s ease, border-color 0.2s ease;
                    animation: sl-fade-up 0.38s ease-out both;
                }
                .org-card:hover {
                    box-shadow: 0 10px 36px rgba(0,0,0,0.08), 0 3px 10px rgba(0,0,0,0.04);
                    transform: translateY(-3px);
                }
                .org-card.expanded {
                    border-color: rgba(168,157,189,0.45);
                    box-shadow: 0 10px 36px rgba(0,0,0,0.08), 0 3px 10px rgba(0,0,0,0.04);
                }
                .user-row-item {
                    transition: background 0.15s ease;
                    cursor: default;
                }
                .user-row-item:hover { background: rgba(168,157,189,0.06) !important; }
                .sl-org-search:focus {
                    outline: none;
                    border-color: #a89dbd !important;
                    box-shadow: 0 0 0 3px rgba(168,157,189,0.15) !important;
                }
                .sl-export-btn:hover:not(:disabled) {
                    box-shadow: 0 6px 20px rgba(44,62,80,0.22) !important;
                    transform: translateY(-1px);
                }
                .sl-export-btn:disabled { opacity: 0.45; cursor: not-allowed; }
                .org-chevron { transition: transform 0.22s cubic-bezier(0.4,0,0.2,1); }
                .org-chevron.open { transform: rotate(180deg); }
            `}</style>
            <Layout
                pagetitle="Org Overview"
                headerTitle="Organisations Overview"
                headerActions={
                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                        <div style={{ position: 'relative' }}>
                            <span style={{
                                position: 'absolute', left: 11, top: '50%',
                                transform: 'translateY(-50%)', color: '#9ca3af',
                                pointerEvents: 'none',
                            }}>
                                <IconSearch />
                            </span>
                            <input
                                type="text"
                                placeholder="Search orgs..."
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                                className="sl-org-search"
                                style={{
                                    paddingLeft: 32, paddingRight: 14,
                                    paddingTop: 8, paddingBottom: 8,
                                    border: '1px solid var(--border-light)',
                                    borderRadius: 10, fontSize: 13,
                                    background: 'white', width: 200,
                                    fontFamily: "'Space Grotesk', sans-serif",
                                    color: 'var(--text-primary)',
                                    transition: 'border-color 0.2s, box-shadow 0.2s',
                                }}
                            />
                        </div>
                        <button
                            onClick={handleCsvExport}
                            disabled={!orgs}
                            className="sl-export-btn"
                            style={{
                                display: 'flex', alignItems: 'center', gap: 7,
                                padding: '8px 16px',
                                background: 'linear-gradient(135deg, #2c3e50 0%, #3d5166 100%)',
                                color: 'white', border: 'none', borderRadius: 10,
                                fontSize: 13, fontWeight: 600, cursor: 'pointer',
                                fontFamily: "'Space Grotesk', sans-serif",
                                boxShadow: '0 2px 8px rgba(44,62,80,0.18)',
                                transition: 'box-shadow 0.2s ease, transform 0.2s ease',
                            }}
                        >
                            <IconDownload /> Export CSV
                        </button>
                    </div>
                }
            >
                <div style={{ padding: '4px 28px 40px' }}>
                    {/* Stats strip */}
                    {orgs && (
                        <div style={{
                            display: 'flex', alignItems: 'center', gap: 6,
                            marginBottom: 24, paddingBottom: 18,
                            borderBottom: '1px solid var(--border-softer)',
                            animation: 'sl-fade-up 0.3s ease-out both',
                        }}>
                            <span style={{
                                fontFamily: "'Syne', sans-serif",
                                fontSize: 22, fontWeight: 800,
                                color: 'var(--text-primary)', lineHeight: 1,
                            }}>
                                {orgs.length}
                            </span>
                            <span style={{
                                fontSize: 13, color: 'var(--text-secondary)',
                                marginRight: 8,
                            }}>
                                {orgs.length === 1 ? 'organisation' : 'organisations'}
                            </span>
                            <span style={{
                                width: 4, height: 4, borderRadius: '50%',
                                background: 'var(--border-light)',
                                marginRight: 8,
                            }} />
                            <span style={{
                                fontFamily: "'Syne', sans-serif",
                                fontSize: 22, fontWeight: 800,
                                color: 'var(--text-primary)', lineHeight: 1,
                            }}>
                                {totalUsers}
                            </span>
                            <span style={{
                                fontSize: 13, color: 'var(--text-secondary)',
                                marginRight: 8,
                            }}>
                                total {totalUsers === 1 ? 'user' : 'users'}
                            </span>
                            {search && filtered.length !== orgs.length && (
                                <>
                                    <span style={{
                                        width: 4, height: 4, borderRadius: '50%',
                                        background: 'var(--border-light)',
                                        marginRight: 8,
                                    }} />
                                    <span style={{
                                        fontSize: 13, color: '#a89dbd', fontWeight: 600,
                                    }}>
                                        {filtered.length} matching
                                    </span>
                                </>
                            )}
                        </div>
                    )}

                    {/* Error */}
                    {error && (
                        <div style={{
                            background: '#fef2f2', border: '1px solid #fecaca',
                            color: '#dc2626', padding: '12px 16px',
                            borderRadius: 12, marginBottom: 20, fontSize: 14,
                        }}>
                            {error}
                        </div>
                    )}

                    {/* Loading */}
                    {!orgs ? (
                        <div style={{
                            display: 'flex', flexDirection: 'column',
                            alignItems: 'center', justifyContent: 'center',
                            padding: '80px 0', gap: 12,
                        }}>
                            <div style={{ display: 'flex', gap: 7, alignItems: 'center' }}>
                                {[0, 150, 300].map(d => (
                                    <span key={d} style={{
                                        width: 7, height: 7, borderRadius: '50%',
                                        background: 'var(--supplier-color)',
                                        animation: 'sl-loading-dot 1.1s ease-in-out infinite',
                                        animationDelay: `${d}ms`,
                                    }}/>
                                ))}
                            </div>
                            <span style={{ fontSize: 13, color: 'var(--text-secondary)' }}>
                                Loading organisations…
                            </span>
                        </div>
                    ) : filtered.length === 0 ? (
                        <div style={{
                            textAlign: 'center', padding: '80px 0',
                            color: 'var(--text-secondary)', fontSize: 14,
                        }}>
                            No organisations {search ? `matching "${search}"` : 'found'}
                        </div>
                    ) : (
                        /* Card grid */
                        <div style={{
                            display: 'grid',
                            gridTemplateColumns: 'repeat(auto-fill, minmax(360px, 1fr))',
                            gap: 14,
                        }}>
                            {filtered.map((org, idx) => {
                                const pal = pick(org.orgName);
                                const isExpanded = expandedOrgId === org.orgId;
                                const newestLogin = org.users
                                    .filter(u => u.lastLogin)
                                    .sort((a, b) => new Date(b.lastLogin) - new Date(a.lastLogin))[0];

                                return (
                                    <div
                                        key={org.orgId}
                                        className={`org-card${isExpanded ? ' expanded' : ''}`}
                                        style={{ animationDelay: `${idx * 45}ms` }}
                                        onClick={() => setExpandedOrgId(isExpanded ? null : org.orgId)}
                                    >
                                        {/* Top accent bar */}
                                        <div style={{
                                            height: 3,
                                            background: pal.bg,
                                            opacity: isExpanded ? 1 : 0.6,
                                            transition: 'opacity 0.2s ease',
                                        }} />

                                        {/* Card header */}
                                        <div style={{
                                            padding: '18px 20px 14px',
                                            display: 'flex', alignItems: 'center', gap: 15,
                                        }}>
                                            {/* Initial avatar */}
                                            <div style={{
                                                width: 54, height: 54, borderRadius: 15,
                                                background: pal.bg,
                                                boxShadow: `0 6px 20px ${pal.glow}`,
                                                display: 'flex', alignItems: 'center', justifyContent: 'center',
                                                flexShrink: 0,
                                            }}>
                                                <span style={{
                                                    fontFamily: "'Syne', sans-serif",
                                                    fontSize: 24, fontWeight: 800,
                                                    color: 'white', lineHeight: 1,
                                                    letterSpacing: '-0.02em',
                                                }}>
                                                    {org.orgName.charAt(0).toUpperCase()}
                                                </span>
                                            </div>

                                            {/* Org name + slug */}
                                            <div style={{ flex: 1, minWidth: 0 }}>
                                                <div style={{
                                                    fontFamily: "'Syne', sans-serif",
                                                    fontSize: 16, fontWeight: 800,
                                                    color: 'var(--text-primary)',
                                                    letterSpacing: '-0.025em', lineHeight: 1.2,
                                                    overflow: 'hidden', textOverflow: 'ellipsis',
                                                    whiteSpace: 'nowrap', marginBottom: 3,
                                                }}>
                                                    {org.orgName}
                                                </div>
                                                <div style={{
                                                    fontFamily: "'DM Mono', monospace",
                                                    fontSize: 11, color: 'var(--text-secondary)',
                                                    letterSpacing: '0.05em',
                                                }}>
                                                    {org.orgSlug}
                                                </div>
                                            </div>

                                            {/* Chevron */}
                                            <div
                                                className={`org-chevron${isExpanded ? ' open' : ''}`}
                                                style={{ color: 'var(--text-secondary)', flexShrink: 0 }}
                                            >
                                                <IconChevron />
                                            </div>
                                        </div>

                                        {/* Stat chips */}
                                        <div style={{
                                            padding: '0 20px 18px',
                                            display: 'flex', gap: 7, flexWrap: 'wrap',
                                        }}>
                                            <span style={{
                                                display: 'inline-flex', alignItems: 'center', gap: 5,
                                                padding: '4px 10px', borderRadius: 999,
                                                background: pal.muted, color: pal.accent,
                                                fontSize: 11.5, fontWeight: 600,
                                                fontFamily: "'Space Grotesk', sans-serif",
                                            }}>
                                                <IconUsers />
                                                {org.users.length} {org.users.length === 1 ? 'user' : 'users'}
                                            </span>
                                            <span style={{
                                                display: 'inline-flex', alignItems: 'center', gap: 5,
                                                padding: '4px 10px', borderRadius: 999,
                                                background: 'rgba(0,0,0,0.03)',
                                                color: 'var(--text-secondary)',
                                                fontSize: 11.5, fontWeight: 500,
                                                fontFamily: "'Space Grotesk', sans-serif",
                                            }}>
                                                <IconCal />
                                                {new Date(org.createdAt).toLocaleDateString('en-US', { month: 'short', year: 'numeric' })}
                                            </span>
                                            {newestLogin && (
                                                <span style={{
                                                    display: 'inline-flex', alignItems: 'center', gap: 5,
                                                    padding: '4px 10px', borderRadius: 999,
                                                    background: 'rgba(109,184,157,0.09)',
                                                    color: '#5aaa8a', fontSize: 11.5, fontWeight: 500,
                                                    fontFamily: "'Space Grotesk', sans-serif",
                                                }}>
                                                    <IconPulse />
                                                    {new Date(newestLogin.lastLogin).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                                                </span>
                                            )}
                                        </div>

                                        {/* Expanded: user list */}
                                        {isExpanded && (
                                            <div
                                                style={{
                                                    borderTop: '1px solid var(--border-softer)',
                                                    background: 'rgba(249,250,251,0.9)',
                                                    animation: 'sl-fade-up 0.18s ease-out both',
                                                }}
                                                onClick={e => e.stopPropagation()}
                                            >
                                                {org.users.length === 0 ? (
                                                    <div style={{
                                                        padding: '18px 20px', textAlign: 'center',
                                                        fontSize: 12, color: 'var(--text-secondary)',
                                                        fontStyle: 'italic',
                                                    }}>
                                                        No users in this organisation
                                                    </div>
                                                ) : (
                                                    <>
                                                        <div style={{
                                                            padding: '10px 20px 6px',
                                                            fontSize: 10, fontWeight: 700,
                                                            letterSpacing: '0.12em',
                                                            textTransform: 'uppercase',
                                                            color: 'var(--text-secondary)',
                                                            fontFamily: "'DM Mono', monospace",
                                                        }}>
                                                            Team
                                                        </div>
                                                        {org.users.map((u, uIdx) => (
                                                            <div
                                                                key={u.userId}
                                                                className="user-row-item"
                                                                style={{
                                                                    padding: '9px 20px',
                                                                    display: 'flex', alignItems: 'center',
                                                                    gap: 10,
                                                                    borderTop: uIdx > 0 ? '1px solid var(--border-softer)' : 'none',
                                                                }}
                                                            >
                                                                {/* User avatar */}
                                                                <div style={{
                                                                    width: 26, height: 26, borderRadius: 8,
                                                                    background: 'linear-gradient(135deg, rgba(168,157,189,0.2) 0%, rgba(109,184,157,0.15) 100%)',
                                                                    display: 'flex', alignItems: 'center',
                                                                    justifyContent: 'center', flexShrink: 0,
                                                                    fontFamily: "'Syne', sans-serif",
                                                                    fontSize: 11, fontWeight: 800,
                                                                    color: '#8573a8',
                                                                }}>
                                                                    {u.email.charAt(0).toUpperCase()}
                                                                </div>

                                                                {/* Email */}
                                                                <div style={{
                                                                    flex: 1, minWidth: 0,
                                                                    fontSize: 12.5, fontWeight: 500,
                                                                    color: 'var(--text-primary)',
                                                                    fontFamily: "'Space Grotesk', sans-serif",
                                                                    overflow: 'hidden', textOverflow: 'ellipsis',
                                                                    whiteSpace: 'nowrap',
                                                                }}>
                                                                    {u.email}
                                                                </div>

                                                                {/* Roles */}
                                                                <div style={{ display: 'flex', gap: 4, flexShrink: 0 }}>
                                                                    {u.roles.length > 0 ? u.roles.map(role => (
                                                                        <span key={role} style={{
                                                                            padding: '2px 8px', borderRadius: 999,
                                                                            background: 'rgba(168,157,189,0.13)',
                                                                            color: '#7c6a9f',
                                                                            fontSize: 10, fontWeight: 700,
                                                                            fontFamily: "'DM Mono', monospace",
                                                                            letterSpacing: '0.04em',
                                                                            whiteSpace: 'nowrap',
                                                                        }}>
                                                                            {role.replace(/_/g, ' ')}
                                                                        </span>
                                                                    )) : (
                                                                        <span style={{
                                                                            fontSize: 11,
                                                                            color: 'var(--text-secondary)',
                                                                        }}>—</span>
                                                                    )}
                                                                </div>

                                                                {/* Last login */}
                                                                <div style={{
                                                                    fontSize: 11, color: 'var(--text-secondary)',
                                                                    fontFamily: "'DM Mono', monospace",
                                                                    flexShrink: 0, width: 58, textAlign: 'right',
                                                                }}>
                                                                    {u.lastLogin
                                                                        ? new Date(u.lastLogin).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: '2-digit' })
                                                                        : 'Never'}
                                                                </div>
                                                            </div>
                                                        ))}
                                                        <div style={{ height: 6 }} />
                                                    </>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            </Layout>
        </>
    );
}
