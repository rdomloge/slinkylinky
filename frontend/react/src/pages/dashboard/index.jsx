import React, { useState, useEffect } from 'react';
import Layout from '@/components/layout/Layout';
import { useAuth } from '@/auth/AuthProvider';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { Link } from 'react-router-dom';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';
import { PanelCard } from '@/components/PanelCard';
import { NavCard } from '@/components/NavCard';

// ─── Helpers ────────────────────────────────────────────────────────────────

function greeting(name) {
    const hour = new Date().getHours();
    const first = name?.split(' ')[0] ?? '';
    if (hour < 12) return `Good morning, ${first}`;
    if (hour < 17) return `Good afternoon, ${first}`;
    return `Good evening, ${first}`;
}

function buildDateRange(monthsBack) {
    const now   = new Date();
    const start = new Date(now.getFullYear(), now.getMonth() - monthsBack, 1);
    const end   = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    const pad   = n => String(n).padStart(2, '0');
    const fmt   = d => `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
    return { start: `${fmt(start)}T00:00`, end: `${fmt(end)}T23:59` };
}

function filterProposals(proposals) {
    return proposals.reduce((acc, p) => {
        const third = p.paidLinks[0].supplier.thirdParty;
        if ((!p.proposalAccepted && p.proposalSent && !third) || (third && !p.blogLive)) acc[0].push(p);
        else if (p.validated && (p.invoicePaid || third)) acc[2].push(p);
        else acc[1].push(p);
        return acc;
    }, [[], [], []]);
}

function fastestSuppliers(proposals) {
    const bySupplier = {};
    proposals
        .filter(p => p.dateSentToSupplier && p.dateAcceptedBySupplier)
        .forEach(p => {
            const domain = p.paidLinks[0].supplier.domain || p.paidLinks[0].supplier.name;
            const days = (new Date(p.dateAcceptedBySupplier) - new Date(p.dateSentToSupplier)) / 86_400_000;
            if (!bySupplier[domain]) bySupplier[domain] = { total: 0, count: 0 };
            bySupplier[domain].total += days;
            bySupplier[domain].count += 1;
        });
    return Object.entries(bySupplier)
        .map(([domain, { total, count }]) => ({ domain, avg: total / count, count }))
        .sort((a, b) => a.avg - b.avg)
        .slice(0, 3);
}

// ─── Sub-components ──────────────────────────────────────────────────────────

/** Hero stat tile — used inside the dark hero banner */
function HeroStat({ label, value, sub, loading, to, accentColor }) {
    const inner = (
        <div className="flex flex-col gap-1 px-6 py-5 rounded-xl transition-all"
             style={{background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.1)'}}>
            <span className="text-xs font-semibold uppercase tracking-widest"
                  style={{color: accentColor, fontFamily: "'JetBrains Mono', monospace"}}>
                {label}
            </span>
            {loading
                ? <div className="h-10 w-20 rounded-lg animate-pulse" style={{background: 'rgba(255,255,255,0.1)'}}/>
                : <span className="text-4xl font-extrabold text-white leading-none"
                        style={{fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.04em'}}>
                    {value ?? '—'}
                  </span>
            }
            {sub && !loading &&
                <span className="text-xs mt-0.5 leading-relaxed" style={{color: 'rgba(255,255,255,0.45)'}}>{sub}</span>
            }
        </div>
    );
    return to ? <Link to={to} className="block hover:scale-[1.02] transition-transform">{inner}</Link> : inner;
}

/** Proposal pipeline — visual strip of proposal states */
function ProposalPipeline({ stats, loading }) {
    if (loading) return (
        <div className="h-14 rounded-xl animate-pulse" style={{background: 'rgba(255,255,255,0.06)'}}/>
    );
    if (!stats) return null;

    const stages = [
        { label: 'Chasing',   count: stats.chasing,   color: '#f97316', bg: 'rgba(249,115,22,0.15)',  border: 'rgba(249,115,22,0.3)'  },
        { label: 'Attention', count: stats.attention,  color: '#eab308', bg: 'rgba(234,179,8,0.15)',   border: 'rgba(234,179,8,0.3)'   },
        { label: 'Complete',  count: stats.complete,   color: '#10b981', bg: 'rgba(16,185,129,0.15)',  border: 'rgba(16,185,129,0.3)'  },
    ];

    return (
        <div className="flex items-center gap-2">
            <span className="text-xs font-semibold uppercase tracking-widest shrink-0"
                  style={{color: 'rgba(255,255,255,0.35)', fontFamily: "'JetBrains Mono', monospace", fontSize: '0.6rem'}}>
                Pipeline
            </span>
            <div className="flex items-center gap-1.5 flex-1">
                {stages.map((s, i) => (
                    <React.Fragment key={s.label}>
                        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full"
                             style={{background: s.bg, border: `1px solid ${s.border}`}}>
                            <span className="text-sm font-bold" style={{color: s.color, fontFamily: "'JetBrains Mono', monospace"}}>
                                {s.count}
                            </span>
                            <span className="text-xs font-medium" style={{color: 'rgba(255,255,255,0.6)'}}>
                                {s.label}
                            </span>
                        </div>
                        {i < stages.length - 1 && (
                            <svg className="w-3 h-3 shrink-0" style={{color: 'rgba(255,255,255,0.2)'}} fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                                <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7"/>
                            </svg>
                        )}
                    </React.Fragment>
                ))}
            </div>
        </div>
    );
}

/** Panel card with optional left-bar accent */
/** Medal rank badge — gold/silver/bronze */
function RankBadge({ rank }) {
    const styles = [
        { bg: '#fef9c3', color: '#a16207', border: '#fde047' }, // gold
        { bg: '#f1f5f9', color: '#475569', border: '#cbd5e1' }, // silver
        { bg: '#fef3c7', color: '#92400e', border: '#fcd34d' }, // bronze
    ];
    const s = styles[rank - 1] ?? styles[2];
    return (
        <span className="w-5 h-5 rounded-full text-xs font-bold flex items-center justify-center shrink-0"
              style={{background: s.bg, color: s.color, border: `1px solid ${s.border}`, fontFamily: "'JetBrains Mono', monospace"}}>
            {rank}
        </span>
    );
}

/** Mini bar chart for supplier onboarding history */
function OnboardingBarChart({ history }) {
    const [hovered, setHovered] = useState(null);
    if (!history?.length) return null;

    const data = [...history].slice(-12); // up to last 12 months, oldest→newest
    const maxCount = Math.max(...data.map(d => d.count), 1);

    return (
        <div className="flex items-end gap-px" style={{height: 80}}>
            {data.map((d, i) => {
                const isEmpty  = d.count === 0;
                const barPct   = isEmpty ? 0 : Math.max(6, Math.round((d.count / maxCount) * 100));
                const month    = new Date(d.yearMonth + '-01')
                    .toLocaleDateString('en-GB', { month: 'short' });
                const isHovered  = hovered === i;
                const anyHovered = hovered !== null;

                return (
                    <div key={d.yearMonth}
                         className="flex-1 flex flex-col items-center justify-end gap-0.5 relative cursor-default"
                         style={{height: '100%'}}
                         onMouseEnter={() => setHovered(i)}
                         onMouseLeave={() => setHovered(null)}>

                        {/* Tooltip */}
                        {isHovered && (
                            <div className="absolute bottom-full mb-1 left-1/2 -translate-x-1/2 z-10
                                            rounded px-1.5 py-0.5 font-bold whitespace-nowrap pointer-events-none"
                                 style={{
                                     background: isEmpty ? '#64748b' : 'var(--supplier-color)',
                                     color: 'white',
                                     fontSize: '0.6rem',
                                     fontFamily: "'JetBrains Mono', monospace",
                                     boxShadow: isEmpty ? '0 2px 8px rgba(0,0,0,0.2)' : '0 2px 8px var(--supplier-glow)',
                                 }}>
                                {d.count}
                            </div>
                        )}

                        {isEmpty ? (
                            /* Zero month — dashed baseline tick */
                            <div className="w-full transition-all duration-150"
                                 style={{
                                     height: 2,
                                     borderTop: `2px dashed ${isHovered ? '#94a3b8' : 'rgba(148,163,184,0.35)'}`,
                                     maxHeight: 'calc(100% - 16px)',
                                 }}/>
                        ) : (
                            /* Normal bar */
                            <div className="w-full rounded-sm transition-all duration-150"
                                 style={{
                                     height: `${barPct}%`,
                                     background: isHovered
                                         ? 'var(--supplier-color)'
                                         : 'var(--supplier-color-light)',
                                     opacity: anyHovered && !isHovered ? 0.35 : 1,
                                     maxHeight: 'calc(100% - 16px)',
                                 }}/>
                        )}

                        {/* Month label */}
                        <span className="shrink-0 select-none"
                              style={{
                                  fontSize: '0.55rem',
                                  lineHeight: 1,
                                  height: 12,
                                  color: isEmpty ? 'rgba(148,163,184,0.5)' : 'rgb(148,163,184)',
                              }}>
                            {month}
                        </span>
                    </div>
                );
            })}
        </div>
    );
}

function SupplierPipelineHealthPanel({ healthData, atRiskData, loading }) {
    function riskColour(count) {
        if (count === 0) return { bg: '#fee2e2', color: '#b91c1c' };
        if (count <= 2)  return { bg: '#ffedd5', color: '#c2410c' };
        return { bg: '#fef3c7', color: '#b45309' };
    }

    return (
        <div className="grid grid-cols-2 gap-4">
            <PanelCard title="Supplier onboarding" loading={loading} to="/supplier" linkLabel="View suppliers" accentColor="var(--supplier-color)">
                {healthData?.history?.length > 0 ? (
                    <>
                        <OnboardingBarChart history={healthData.history}/>
                        <div className="flex items-baseline gap-1.5 pt-1 border-t" style={{borderColor: 'var(--supplier-border)'}}>
                            <span className="text-2xl font-bold" style={{fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.03em', color: 'var(--supplier-color)'}}>
                                {healthData.thisMonth ?? 0}
                            </span>
                            <span className="text-xs text-slate-400">new suppliers this month</span>
                        </div>
                    </>
                ) : (
                    <p className="text-xs text-slate-400">No onboarding history yet.</p>
                )}
            </PanelCard>

            <PanelCard title="At-risk demand sites" loading={loading} to="/demandsites" linkLabel="View all sites" accentColor="#ef4444">
                <div className="flex items-center gap-2 mb-3">
                    <span className="px-2 py-0.5 rounded-full text-xs font-semibold"
                          style={(atRiskData?.sites?.length ?? 0) === 0
                              ? {background: '#dcfce7', color: '#15803d'}
                              : {background: '#fee2e2', color: '#b91c1c'}}>
                        {atRiskData?.sites?.length ?? 0} at risk
                    </span>
                    <span className="text-xs text-slate-400">
                        fewer than {atRiskData?.threshold ?? 5} available suppliers
                    </span>
                </div>
                {(atRiskData?.sites?.length ?? 0) === 0 ? (
                    <p className="text-xs text-slate-400">All demand sites are healthy.</p>
                ) : (
                    <>
                        <div className="space-y-0.5">
                            {atRiskData.sites.slice(0, 6).map(site => {
                                const rc = riskColour(site.availableCount);
                                return (
                                    <div key={site.id}
                                         className="flex items-center justify-between py-1 border-b border-slate-50 last:border-0">
                                        <div className="min-w-0">
                                            <p className="text-xs text-slate-700 truncate">{site.name}</p>
                                            <p className="text-xs text-slate-400 truncate">{site.domain}</p>
                                        </div>
                                        <span className="shrink-0 ml-2 px-1.5 py-0.5 rounded-full text-xs font-semibold"
                                              style={{background: rc.bg, color: rc.color}}>
                                            {site.availableCount}
                                        </span>
                                    </div>
                                );
                            })}
                        </div>
                        {atRiskData.topNeededCategories?.length > 0 && (
                            <div className="pt-3 border-t border-slate-100 mt-1">
                                <p className="text-xs font-medium text-slate-500 mb-1.5">Most needed categories</p>
                                <div className="flex flex-wrap gap-1">
                                    {atRiskData.topNeededCategories.slice(0, 8).map(cat => (
                                        <span key={cat.categoryId}
                                              className="px-2 py-0.5 rounded-full text-xs"
                                              style={{background: 'var(--demandsite-bg)', color: 'var(--demandsite-color)', border: '1px solid var(--demandsite-border)'}}>
                                            {cat.categoryName}
                                            <span className="ml-1 opacity-50">×{cat.siteCount}</span>
                                        </span>
                                    ))}
                                </div>
                            </div>
                        )}
                    </>
                )}
            </PanelCard>
        </div>
    );
}

// ─── Nav section definitions ─────────────────────────────────────────────────

const navSections = [
    {
        to: '/demand', label: 'Demand', description: 'Manage and fulfil link demands',
        accentColor: 'var(--demand-color)',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25 5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z"/></svg>,
    },
    {
        to: '/categories', label: 'Categories', description: 'Organise demand and supplier categories',
        accentColor: '#94a3b8',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z"/><path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6Z"/></svg>,
    },
    {
        to: '/supplier', label: 'Suppliers', description: 'Search and manage your supplier network',
        accentColor: 'var(--supplier-color)',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z"/></svg>,
    },
    {
        to: '/proposals', label: 'Proposals', description: 'Track workflow from sent to live',
        accentColor: '#6366f1',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"/></svg>,
    },
    {
        to: '/demandsites', label: 'Demand Sites', description: 'Manage client sites and their demand',
        accentColor: 'var(--demandsite-color)',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/><path strokeLinecap="round" strokeLinejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"/></svg>,
    },
    {
        to: '/audit', label: 'Audit', description: 'Review activity and trace changes',
        accentColor: '#64748b',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z"/></svg>,
    },
];

const ordersSection = {
    to: '/orders', label: 'Orders', description: 'Monitor orders end-to-end',
    accentColor: '#f472b6',
    icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="m21 7.5-9-5.25L3 7.5m18 0-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9"/></svg>,
};

// ─── Dashboard ───────────────────────────────────────────────────────────────

export default function Dashboard() {
    const { user } = useAuth();

    const [demandCount, setDemandCount]         = useState(null);
    const [activeSuppliers, setActiveSuppliers] = useState(null);
    const [proposalStats, setProposalStats]     = useState(null);
    const [attentionProposals, setAttentionProposals] = useState([]);
    const [unproposedDemands, setUnproposedDemands]   = useState([]);
    const [missingCatSites, setMissingCatSites] = useState([]);
    const [missingCatSuppliers, setMissingCatSuppliers] = useState([]);
    const [topSuppliers, setTopSuppliers]       = useState([]);
    const [topUsedSuppliersList, setTopUsedSuppliersList] = useState([]);
    const [topDemandSites, setTopDemandSites]   = useState([]);
    const [supplierHealth, setSupplierHealth]   = useState(null);
    const [atRiskSites, setAtRiskSites]         = useState(null);
    const [loading, setLoading]                 = useState(true);

    useEffect(() => {
        if (!user) return;

        const thisMonth = buildDateRange(0);
        const sixMonths = buildDateRange(6);

        const safeJson = url => fetchWithAuth(url)
            .then(r => r.ok ? r.json() : Promise.reject())
            .catch(() => null);

        Promise.all([
            safeJson('/.rest/demandsupport/findUnsatisfied?sort=requested'),
            safeJson('/.rest/suppliers/search/countByDisabledFalse'),
            safeJson(`/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${thisMonth.start}&endDate=${thisMonth.end}&projection=fullProposal`),
            safeJson(`/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${sixMonths.start}&endDate=${sixMonths.end}&projection=fullProposal`),
            safeJson('/.rest/paidlinksupport/topbysuppliers?limit=5'),
            safeJson('/.rest/demandssitesupport/missingCategories'),
            safeJson('/.rest/suppliers/search/findByCategoriesIsEmptyAndDisabledFalse?projection=fullSupplier'),
            safeJson('/.rest/demandssitesupport/topbydemands?limit=5'),
            safeJson('/.rest/supplierHealthSupport/onboarding?months=12'),
            safeJson('/.rest/supplierHealthSupport/atrisk?threshold=5'),
        ]).then(([demands, suppliers, thisMonthProposals, sixMonthProposals, topSuppliersData, missingSites, missingCatSuppliersData, allSitesPage, onboardingData, atRiskData]) => {

            if (demands) { setDemandCount(demands.length); setUnproposedDemands(demands.slice(0, 5)); }
            if (suppliers != null) setActiveSuppliers(suppliers);

            if (thisMonthProposals) {
                const [waitingForSupplier, waitingForAdmin, complete] = filterProposals(thisMonthProposals);
                setProposalStats({
                    total:     thisMonthProposals.length,
                    attention: waitingForAdmin.length,
                    chasing:   waitingForSupplier.length,
                    complete:  complete.length,
                });
                setAttentionProposals(waitingForAdmin.slice(0, 5));
            }

            if (sixMonthProposals) setTopSuppliers(fastestSuppliers(sixMonthProposals));
            if (topSuppliersData) setTopUsedSuppliersList(topSuppliersData);

            if (missingSites) setMissingCatSites(missingSites);
            setMissingCatSuppliers(missingCatSuppliersData?._embedded?.suppliers ?? missingCatSuppliersData ?? []);
            setTopDemandSites(allSitesPage ?? []);

            if (onboardingData) setSupplierHealth(onboardingData);
            if (atRiskData)     setAtRiskSites(atRiskData);

            setLoading(false);
        }).catch(() => setLoading(false));
    }, [user]);

    const today = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    return (
        <Layout pagetitle="Dashboard" headerTitle="Dashboard">
            <div className="p-6 max-w-5xl space-y-6">

                {/* ── Hero banner ───────────────────────────────────── */}
                <div className="rounded-2xl overflow-hidden"
                     style={{background: 'linear-gradient(135deg, #0f172a 0%, #1e1b4b 55%, #2e1065 100%)', boxShadow: '0 20px 40px rgba(15,23,42,0.35)'}}>

                    {/* Subtle noise texture overlay */}
                    <div className="px-7 pt-7 pb-5">
                        <p className="text-xs font-medium mb-1" style={{color: 'rgba(255,255,255,0.3)', fontFamily: "'JetBrains Mono', monospace", letterSpacing: '0.12em'}}>
                            {today.toUpperCase()}
                        </p>
                        <h1 className="text-3xl font-extrabold text-white mb-5"
                            style={{fontFamily: "'Outfit', sans-serif", letterSpacing: '-0.03em'}}>
                            {greeting(user?.name)}
                        </h1>

                        {/* Three key stats */}
                        <div className="grid grid-cols-3 gap-3 mb-5">
                            <HeroStat
                                label="Active demands"
                                value={demandCount}
                                loading={loading}
                                to="/demand"
                                accentColor="var(--demand-color-light)"
                            />
                            <HeroStat
                                label="Active suppliers"
                                value={activeSuppliers}
                                loading={loading}
                                to="/supplier"
                                accentColor="var(--supplier-color-light)"
                            />
                            <HeroStat
                                label="Proposals this month"
                                value={proposalStats?.total}
                                loading={loading}
                                to="/proposals"
                                accentColor="#a5b4fc"
                            />
                        </div>

                        {/* Proposal pipeline strip */}
                        <ProposalPipeline stats={proposalStats} loading={loading}/>
                    </div>
                </div>

                {/* ── Insight panels ────────────────────────────────── */}
                <div className="grid grid-cols-3 gap-4">

                    {/* Fastest suppliers */}
                    <PanelCard title="Fastest to respond" loading={loading} to="/supplier" accentColor="var(--supplier-color)">
                        {topSuppliers.length === 0
                            ? <p className="text-xs text-slate-400">Not enough data yet.</p>
                            : topSuppliers.map((s, i) => (
                                <div key={s.domain} className="flex items-center justify-between py-1.5 border-b border-slate-50 last:border-0">
                                    <div className="flex items-center gap-2 min-w-0">
                                        <RankBadge rank={i + 1}/>
                                        <span className="text-sm text-slate-700 truncate">{s.domain}</span>
                                    </div>
                                    <span className="text-xs font-semibold shrink-0 ml-2" style={{color: 'var(--supplier-color)', fontFamily: "'JetBrains Mono', monospace"}}>
                                        {s.avg < 1 ? '<1d' : `${Math.round(s.avg)}d`}
                                        <span className="text-slate-300 font-normal ml-1">({s.count})</span>
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                    {/* Missing categories */}
                    <PanelCard title="Missing categories" loading={loading} accentColor="#f59e0b">
                        <div>
                            <p className="text-xs font-medium text-slate-500 mb-1.5">
                                Demand sites
                                <span className="ml-1.5 px-1.5 py-0.5 rounded-full text-xs font-semibold"
                                      style={missingCatSites.length === 0
                                          ? {background: '#dcfce7', color: '#15803d'}
                                          : {background: 'var(--demand-bg)', color: 'var(--demand-color)'}}>
                                    {missingCatSites.length}
                                </span>
                            </p>
                            {missingCatSites.length === 0
                                ? <p className="text-xs text-slate-400">All sites have categories</p>
                                : missingCatSites.slice(0, 3).map(ds => (
                                    <div key={ds.id} className="flex items-center justify-between py-1 border-b border-slate-50 last:border-0">
                                        <div className="min-w-0">
                                            <p className="text-xs text-slate-700 truncate">{ds.name}</p>
                                            <p className="text-xs text-slate-400 truncate">{ds.domain}</p>
                                        </div>
                                        <Link to={`/demandsites/${ds.id}`} className="shrink-0 ml-2 text-xs font-medium hover:underline" style={{color: 'var(--demandsite-color)'}}>Edit →</Link>
                                    </div>
                                ))
                            }
                        </div>
                        <div className="mt-3 pt-3 border-t border-slate-100">
                            <p className="text-xs font-medium text-slate-500 mb-1.5">
                                Suppliers
                                <span className="ml-1.5 px-1.5 py-0.5 rounded-full text-xs font-semibold"
                                      style={missingCatSuppliers.length === 0
                                          ? {background: '#dcfce7', color: '#15803d'}
                                          : {background: 'var(--supplier-bg)', color: 'var(--supplier-color)'}}>
                                    {missingCatSuppliers.length}
                                </span>
                            </p>
                            {missingCatSuppliers.length === 0
                                ? <p className="text-xs text-slate-400">All active suppliers have categories</p>
                                : missingCatSuppliers.slice(0, 3).map(s => (
                                    <div key={s.id} className="flex items-center justify-between py-1 border-b border-slate-50 last:border-0">
                                        <span className="text-xs text-slate-700 truncate">{s.domain || s.name}</span>
                                        <Link to={`/supplier/${s.id}`} className="shrink-0 ml-2 text-xs font-medium hover:underline" style={{color: 'var(--supplier-color)'}}>Edit →</Link>
                                    </div>
                                ))
                            }
                        </div>
                    </PanelCard>

                    {/* Action items */}
                    <PanelCard title="Needs attention" loading={loading} accentColor="#ef4444">
                        <div>
                            <p className="text-xs font-medium text-slate-500 mb-1.5">
                                Demand to fulfil
                                {demandCount !== null &&
                                    <span className="ml-1.5 px-1.5 py-0.5 rounded-full text-xs font-semibold"
                                          style={{background: 'var(--demand-bg)', color: 'var(--demand-color)'}}>
                                        {demandCount}
                                    </span>
                                }
                            </p>
                            {unproposedDemands.length === 0
                                ? <p className="text-xs text-slate-400">None outstanding</p>
                                : unproposedDemands.map(d => (
                                    <div key={d.id} className="flex items-center justify-between py-1 border-b border-slate-50 last:border-0">
                                        <span className="text-xs text-slate-700 truncate">{d.name}</span>
                                        <Link to={`/supplier/search/${d.id}`} className="shrink-0 ml-2 text-xs font-semibold hover:underline" style={{color: 'var(--demand-color)'}}>Fulfil →</Link>
                                    </div>
                                ))
                            }
                        </div>
                        <div className="mt-3 pt-3 border-t border-slate-100">
                            <p className="text-xs font-medium text-slate-500 mb-1.5">
                                Proposals needing attention
                                {proposalStats &&
                                    <span className="ml-1.5 px-1.5 py-0.5 rounded-full text-xs font-semibold"
                                          style={{background: '#ede9fe', color: '#7c3aed'}}>
                                        {proposalStats.attention}
                                    </span>
                                }
                            </p>
                            {attentionProposals.length === 0
                                ? <p className="text-xs text-slate-400">None this month</p>
                                : attentionProposals.map(p => (
                                    <div key={p.id} className="flex items-center justify-between py-1 border-b border-slate-50 last:border-0">
                                        <span className="text-xs text-slate-700 truncate">{p.paidLinks[0].supplier.domain || p.paidLinks[0].supplier.name}</span>
                                        <Link to={`/proposals/${p.id}`} className="shrink-0 ml-2 text-xs font-semibold hover:underline" style={{color: '#6366f1'}}>View →</Link>
                                    </div>
                                ))
                            }
                        </div>
                    </PanelCard>

                </div>

                {/* ── Supplier pipeline health ───────────────────────── */}
                <SupplierPipelineHealthPanel
                    healthData={supplierHealth}
                    atRiskData={atRiskSites}
                    loading={loading}
                />

                {/* ── Usage leaderboards ────────────────────────────── */}
                <div className="grid grid-cols-2 gap-4">

                    <PanelCard title="Most used suppliers" loading={loading} to="/supplier" accentColor="var(--supplier-color)">
                        {topUsedSuppliersList.length === 0
                            ? <p className="text-xs text-slate-400">Not enough data yet.</p>
                            : topUsedSuppliersList.map((s, i) => (
                                <div key={s.domain} className="flex items-center justify-between py-1.5 border-b border-slate-50 last:border-0">
                                    <div className="flex items-center gap-2 min-w-0">
                                        <RankBadge rank={i + 1}/>
                                        <span className="text-sm text-slate-700 truncate">{s.domain}</span>
                                    </div>
                                    <span className="text-xs font-semibold shrink-0 ml-2" style={{color: 'var(--supplier-color)', fontFamily: "'JetBrains Mono', monospace"}}>
                                        {s.linkCount} {s.linkCount === 1 ? 'link' : 'links'}
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                    <PanelCard title="Most active demand sites" loading={loading} to="/demandsites" accentColor="var(--demandsite-color)">
                        {topDemandSites.length === 0
                            ? <p className="text-xs text-slate-400">No data yet.</p>
                            : topDemandSites.map((ds, i) => (
                                <div key={ds.id} className="flex items-center justify-between py-1.5 border-b border-slate-50 last:border-0">
                                    <div className="flex items-center gap-2 min-w-0">
                                        <RankBadge rank={i + 1}/>
                                        <div className="min-w-0">
                                            <p className="text-sm text-slate-700 truncate">{ds.name}</p>
                                            <p className="text-xs text-slate-400 truncate">{ds.domain}</p>
                                        </div>
                                    </div>
                                    <span className="text-xs font-semibold shrink-0 ml-2" style={{color: 'var(--demandsite-color)', fontFamily: "'JetBrains Mono', monospace"}}>
                                        {ds.demandCount ?? 0} {(ds.demandCount ?? 0) === 1 ? 'demand' : 'demands'}
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                </div>

                {/* ── Quick nav ─────────────────────────────────────── */}
                <div>
                    <p className="text-xs font-semibold uppercase tracking-widest mb-3"
                       style={{color: '#94a3b8', fontFamily: "'JetBrains Mono', monospace", fontSize: '0.6rem'}}>
                        Navigate
                    </p>
                    <div className="grid grid-cols-3 gap-3">
                        {navSections.map(s => <NavCard key={s.to} {...s}/>)}
                        <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                            <NavCard {...ordersSection}/>
                        </AuthorizedAccess>
                    </div>
                </div>

            </div>
        </Layout>
    );
}
