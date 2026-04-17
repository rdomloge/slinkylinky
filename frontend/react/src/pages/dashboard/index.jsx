import React, { useState, useEffect, useRef } from 'react';
import Layout from '@/components/layout/Layout';
import { useAuth } from '@/auth/AuthProvider';
import { getTenantOverride } from '@/auth/TenantOverrideContext';
import { Link } from 'react-router-dom';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';
import { PanelCard } from '@/components/PanelCard';
import { NavCard } from '@/components/NavCard';

// ─── Cache helpers ────────────────────────────────────────────────────────────

const CACHE_TTL = 15 * 60 * 1000; // 15 minutes

function getCacheKey(email, orgId) {
    return `sl_dashboard_${email}_${orgId || 'native'}`;
}

function readCache(key) {
    try {
        const raw = localStorage.getItem(key);
        return raw ? JSON.parse(raw) : null;
    } catch {
        return null;
    }
}

function writeCache(key, displayState) {
    try {
        localStorage.setItem(key, JSON.stringify({ fetchedAt: Date.now(), displayState }));
    } catch {
        // Ignore quota errors
    }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

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

function buildDashboardUrls() {
    const thisMonth = buildDateRange(0);
    const sixMonths = buildDateRange(6);
    return [
        '/.rest/demandsupport/findUnsatisfied?sort=requested',
        '/.rest/suppliers/search/countByDisabledFalse',
        `/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${thisMonth.start}&endDate=${thisMonth.end}&projection=fullProposal`,
        `/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${sixMonths.start}&endDate=${sixMonths.end}&projection=fullProposal`,
        '/.rest/paidlinksupport/topbysuppliers?limit=5',
        '/.rest/demandssitesupport/missingCategories',
        '/.rest/suppliers/search/findByCategoriesIsEmptyAndDisabledFalseAndThirdPartyFalse?projection=fullSupplier',
        '/.rest/demandssitesupport/topbydemands?limit=5',
        '/.rest/supplierHealthSupport/onboarding?months=12',
        '/.rest/supplierHealthSupport/atrisk?threshold=5',
        '/.rest/engagements/expiring-soon',
    ];
}

/**
 * Converts an ISO expiry timestamp into a human-readable countdown label and urgency level.
 * Levels: 'critical' (<4 h), 'warning' (<12 h), 'caution' (<24 h), 'ok' (>24 h).
 */
function formatTimeRemaining(expiresAt) {
    if (!expiresAt) return { label: '—', level: 'ok' };
    const ms = new Date(expiresAt) - Date.now();
    if (ms <= 0) return { label: 'Overdue', level: 'critical' };
    const hours = ms / 3_600_000;
    if (hours < 4)  return { label: `${Math.floor(hours)}h ${Math.floor((hours % 1) * 60)}m`, level: 'critical' };
    if (hours < 12) return { label: `${Math.floor(hours)}h left`, level: 'warning' };
    const days = Math.floor(hours / 24);
    const rem  = Math.floor(hours % 24);
    return { label: rem > 0 ? `${days}d ${rem}h` : `${days}d`, level: 'ok' };
}

/** Converts raw API results array into a serialisable display-state object */
function processResults([demands, suppliers, thisMonthProposals, sixMonthProposals, topSuppliersData, missingSites, missingCatSuppliersData, allSitesPage, onboardingData, atRiskData, expiringEngagementsData]) {
    const s = {
        demandCount: null,
        activeSuppliers: null,
        proposalStats: null,
        attentionProposals: [],
        unproposedDemands: [],
        missingCatSites: [],
        missingCatSuppliers: [],
        topSuppliers: [],
        topUsedSuppliersList: [],
        topDemandSites: [],
        supplierHealth: null,
        atRiskSites: null,
        expiringEngagements: [],
    };

    if (demands) {
        s.demandCount = demands.length;
        s.unproposedDemands = demands.slice(0, 5);
    }
    if (suppliers != null) s.activeSuppliers = suppliers;

    if (thisMonthProposals) {
        const [waitingForSupplier, waitingForAdmin, complete] = filterProposals(thisMonthProposals);
        s.proposalStats = {
            total: thisMonthProposals.length,
            attention: waitingForAdmin.length,
            chasing: waitingForSupplier.length,
            complete: complete.length,
        };
        s.attentionProposals = waitingForAdmin.slice(0, 5);
    }

    if (sixMonthProposals) s.topSuppliers = fastestSuppliers(sixMonthProposals);
    if (topSuppliersData) s.topUsedSuppliersList = topSuppliersData;
    if (missingSites) s.missingCatSites = missingSites;
    s.missingCatSuppliers = missingCatSuppliersData?._embedded?.suppliers ?? missingCatSuppliersData ?? [];
    s.topDemandSites = allSitesPage ?? [];
    if (onboardingData) s.supplierHealth = onboardingData;
    if (atRiskData) s.atRiskSites = atRiskData;
    s.expiringEngagements = Array.isArray(expiringEngagementsData) ? expiringEngagementsData : [];

    return s;
}

// ─── CSS animations ───────────────────────────────────────────────────────────

const KEYFRAMES = `
@keyframes dashOrbit1 {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
}
@keyframes dashOrbit2 {
    from { transform: rotate(0deg); }
    to   { transform: rotate(-360deg); }
}
@keyframes dashOrbit3 {
    from { transform: rotate(45deg); }
    to   { transform: rotate(405deg); }
}
@keyframes dashCorePulse {
    0%, 100% { opacity: 0.6; transform: scale(1);    box-shadow: 0 0 12px rgba(129,140,248,0.5); }
    50%       { opacity: 1;   transform: scale(1.25); box-shadow: 0 0 28px rgba(192,132,252,0.8); }
}
@keyframes dashDotBounce {
    0%, 80%, 100% { transform: translateY(0);    opacity: 0.3; }
    40%            { transform: translateY(-8px); opacity: 1;   }
}
@keyframes dashRefreshPillIn {
    from { opacity: 0; transform: translateY(-8px) scale(0.85); }
    to   { opacity: 1; transform: translateY(0)    scale(1);    }
}
@keyframes dashRefreshSpin {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
}
@keyframes dashCheckDraw {
    from { stroke-dashoffset: 22; opacity: 0; }
    to   { stroke-dashoffset: 0;  opacity: 1; }
}
@keyframes dashCheckPop {
    0%   { transform: scale(0.4) rotate(-15deg); opacity: 0; }
    60%  { transform: scale(1.2) rotate(4deg);   opacity: 1; }
    100% { transform: scale(1)   rotate(0deg);   opacity: 1; }
}
@keyframes dashHeroShine {
    from { left: -60%;  opacity: 0;    }
    30%  {              opacity: 0.09; }
    to   { left: 130%;  opacity: 0;    }
}
/* ── Refresh pill enhancements ── */
@keyframes dashPillGlow {
    0%, 100% { box-shadow: 0 0 18px rgba(129,140,248,0.45), 0 2px 14px rgba(0,0,0,0.55); }
    50%       { box-shadow: 0 0 36px rgba(129,140,248,0.85), 0 0 18px rgba(129,140,248,0.35), 0 2px 14px rgba(0,0,0,0.55); }
}
@keyframes dashPillPing {
    0%   { transform: scale(1);    opacity: 0.7; }
    100% { transform: scale(1.9);  opacity: 0;   }
}
@keyframes dashUpdatedBurst {
    0%   { transform: scale(0.78); opacity: 0; box-shadow: 0 0 0   rgba(52,211,153,0);    }
    45%  { transform: scale(1.1);  opacity: 1; box-shadow: 0 0 36px rgba(52,211,153,0.6); }
    100% { transform: scale(1);    opacity: 1; box-shadow: 0 0 24px rgba(52,211,153,0.3); }
}
/* ── Data reveal transition ── */
@keyframes dashScanLine {
    0%   { top: -2px;  opacity: 0; }
    6%   {             opacity: 1; }
    93%  {             opacity: 1; }
    100% { top: 100%;  opacity: 0; }
}
@keyframes dashDataReveal {
    0%   { opacity: 0.28; transform: translateY(12px) scale(0.995); }
    55%  { opacity: 1;    transform: translateY(-3px)  scale(1.003); }
    100% { opacity: 1;    transform: translateY(0)     scale(1);     }
}
@keyframes dashHeroFlash {
    0%   { opacity: 0; }
    16%  { opacity: 1; }
    100% { opacity: 0; }
}
`;

// ─── Sub-components ───────────────────────────────────────────────────────────

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

    const data = [...history].slice(-12);
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
                            <div className="w-full transition-all duration-150"
                                 style={{
                                     height: 2,
                                     borderTop: `2px dashed ${isHovered ? '#94a3b8' : 'rgba(148,163,184,0.35)'}`,
                                     maxHeight: 'calc(100% - 16px)',
                                 }}/>
                        ) : (
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

// ─── Nav section definitions ──────────────────────────────────────────────────

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

// ─── Cache-state visual components ────────────────────────────────────────────

/** Full-width banner shown when there is no cached data and the worker is fetching for the first time */
function FirstLoadBanner() {
    return (
        <div style={{
            borderRadius: 16,
            overflow: 'hidden',
            background: 'linear-gradient(135deg, #0f172a 0%, #1e1b4b 55%, #2e1065 100%)',
            boxShadow: '0 20px 40px rgba(15,23,42,0.35)',
            padding: '4rem 2rem 3.5rem',
            textAlign: 'center',
            position: 'relative',
        }}>
            {/* Ambient glow blobs */}
            <div style={{
                position: 'absolute', top: -60, left: '15%', width: 280, height: 280,
                borderRadius: '50%', pointerEvents: 'none',
                background: 'radial-gradient(circle, rgba(129,140,248,0.13) 0%, transparent 68%)',
            }}/>
            <div style={{
                position: 'absolute', bottom: -40, right: '12%', width: 320, height: 320,
                borderRadius: '50%', pointerEvents: 'none',
                background: 'radial-gradient(circle, rgba(192,132,252,0.10) 0%, transparent 68%)',
            }}/>

            {/* Orbital spinner */}
            <div style={{ position: 'relative', width: 80, height: 80, margin: '0 auto 32px', flexShrink: 0 }}>
                {/* Outer ring — slow clockwise */}
                <div style={{
                    position: 'absolute', inset: 0, borderRadius: '50%',
                    border: '1.5px solid transparent',
                    borderTopColor: '#818cf8',
                    borderRightColor: 'rgba(129,140,248,0.18)',
                    animation: 'dashOrbit1 2.2s linear infinite',
                }}/>
                {/* Outer ring opposing arc */}
                <div style={{
                    position: 'absolute', inset: 0, borderRadius: '50%',
                    border: '1.5px solid transparent',
                    borderBottomColor: 'rgba(129,140,248,0.35)',
                    animation: 'dashOrbit1 2.2s linear infinite',
                }}/>
                {/* Mid ring — faster counter-clockwise */}
                <div style={{
                    position: 'absolute', inset: 13, borderRadius: '50%',
                    border: '1.5px solid transparent',
                    borderTopColor: '#c084fc',
                    borderLeftColor: 'rgba(192,132,252,0.22)',
                    animation: 'dashOrbit2 1.5s linear infinite',
                }}/>
                {/* Inner ring — medium clockwise offset */}
                <div style={{
                    position: 'absolute', inset: 26, borderRadius: '50%',
                    border: '1.5px solid transparent',
                    borderTopColor: 'rgba(165,180,252,0.7)',
                    animation: 'dashOrbit3 1.0s linear infinite',
                }}/>
                {/* Core pulsing dot */}
                <div style={{
                    position: 'absolute', inset: 0,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                    <div style={{
                        width: 10, height: 10, borderRadius: '50%',
                        background: 'linear-gradient(135deg, #818cf8 0%, #c084fc 100%)',
                        animation: 'dashCorePulse 1.8s ease-in-out infinite',
                    }}/>
                </div>
            </div>

            {/* Heading */}
            <h2 style={{
                fontFamily: "'Outfit', sans-serif",
                fontSize: '1.65rem', fontWeight: 800,
                color: 'white', letterSpacing: '-0.03em',
                margin: '0 0 10px',
            }}>
                Loading dashboard data for the first time
            </h2>

            {/* Subtitle */}
            <p style={{
                fontFamily: "'JetBrains Mono', monospace",
                fontSize: '0.75rem', letterSpacing: '0.06em',
                color: 'rgba(255,255,255,0.38)',
                margin: '0 0 28px',
            }}>
                Building your workspace overview · just a moment
            </p>

            {/* Staggered bounce dots */}
            <div style={{ display: 'flex', justifyContent: 'center', gap: 7 }}>
                {[0, 1, 2, 3, 4].map(i => (
                    <div key={i} style={{
                        width: 6, height: 6, borderRadius: '50%',
                        background: `rgba(${i % 2 === 0 ? '129,140,248' : '192,132,252'},0.75)`,
                        animation: `dashDotBounce 1.3s ease-in-out ${i * 0.13}s infinite`,
                    }}/>
                ))}
            </div>
        </div>
    );
}

/**
 * Small pill shown in the hero when background data is refreshing or has just finished.
 * phase: 'refreshing' | 'refreshed'
 */
function HeroRefreshPill({ phase }) {
    const isDone = phase === 'refreshed';
    return (
        <div style={{ position: 'relative', display: 'inline-block' }}>
            {/* Sonar ping ring — pulses continuously while refreshing */}
            {!isDone && (
                <div style={{
                    position: 'absolute', inset: -6, borderRadius: 30,
                    border: '1.5px solid rgba(129,140,248,0.65)',
                    animation: 'dashPillPing 1.7s ease-out 0.9s infinite',
                    pointerEvents: 'none',
                }}/>
            )}

            <div style={{
                display: 'inline-flex', alignItems: 'center', gap: 9,
                borderRadius: 22, padding: '8px 18px',
                backdropFilter: 'blur(16px)',
                background: isDone ? 'rgba(4,18,10,0.9)' : 'rgba(8,12,26,0.9)',
                border: `1.5px solid ${isDone ? 'rgba(52,211,153,0.65)' : 'rgba(129,140,248,0.65)'}`,
                animation: isDone
                    ? 'dashUpdatedBurst 0.45s cubic-bezier(0.34,1.56,0.64,1) both'
                    : 'dashRefreshPillIn 0.35s cubic-bezier(0.34,1.56,0.64,1) both, dashPillGlow 2s ease-in-out 0.6s infinite',
            }}>
                {isDone ? (
                    <>
                        <svg width="15" height="15" viewBox="0 0 15 15" fill="none"
                             style={{ flexShrink: 0, animation: 'dashCheckPop 0.4s cubic-bezier(0.34,1.56,0.64,1) 0.1s both' }}>
                            <path d="M2.5 8l4 4 6-7"
                                  stroke="#34d399" strokeWidth="2.2"
                                  strokeLinecap="round" strokeLinejoin="round"
                                  style={{
                                      strokeDasharray: 22,
                                      strokeDashoffset: 0,
                                      animation: 'dashCheckDraw 0.4s ease 0.2s both',
                                  }}/>
                        </svg>
                        <span style={{
                            fontFamily: "'JetBrains Mono', monospace",
                            fontSize: '0.72rem', letterSpacing: '0.13em', fontWeight: 700,
                            color: '#34d399',
                        }}>UPDATED</span>
                    </>
                ) : (
                    <>
                        <div style={{
                            width: 13, height: 13, flexShrink: 0, borderRadius: '50%',
                            border: '2px solid rgba(129,140,248,0.2)',
                            borderTopColor: '#818cf8',
                            animation: 'dashRefreshSpin 0.65s linear infinite',
                        }}/>
                        <span style={{
                            fontFamily: "'JetBrains Mono', monospace",
                            fontSize: '0.72rem', letterSpacing: '0.13em', fontWeight: 600,
                            color: 'rgba(165,180,252,0.95)',
                        }}>REFRESHING</span>
                    </>
                )}
            </div>
        </div>
    );
}

// ─── Dashboard ────────────────────────────────────────────────────────────────

export default function Dashboard() {
    const { user, accessToken } = useAuth();

    // ── Data state ──────────────────────────────────────────────────────────
    const [demandCount, setDemandCount]                   = useState(null);
    const [activeSuppliers, setActiveSuppliers]           = useState(null);
    const [proposalStats, setProposalStats]               = useState(null);
    const [attentionProposals, setAttentionProposals]     = useState([]);
    const [unproposedDemands, setUnproposedDemands]       = useState([]);
    const [missingCatSites, setMissingCatSites]           = useState([]);
    const [missingCatSuppliers, setMissingCatSuppliers]   = useState([]);
    const [topSuppliers, setTopSuppliers]                 = useState([]);
    const [topUsedSuppliersList, setTopUsedSuppliersList] = useState([]);
    const [topDemandSites, setTopDemandSites]             = useState([]);
    const [supplierHealth, setSupplierHealth]             = useState(null);
    const [atRiskSites, setAtRiskSites]                   = useState(null);
    const [expiringEngagements, setExpiringEngagements]   = useState([]);
    const [loading, setLoading]                           = useState(true);

    // ── Cache / phase state ─────────────────────────────────────────────────
    // 'init' | 'firstLoad' | 'fresh' | 'refreshing' | 'refreshed'
    const [phase, setPhase]                     = useState('init');
    const [isTransitioning, setIsTransitioning] = useState(false);
    const [dataRevealActive, setDataRevealActive] = useState(false);
    const workerRef                             = useRef(null);

    // ── Apply a display-state object to all data state setters ─────────────
    function applyDisplayState(s) {
        if (s.demandCount           !== undefined) setDemandCount(s.demandCount);
        if (s.activeSuppliers       !== undefined) setActiveSuppliers(s.activeSuppliers);
        if (s.proposalStats         !== undefined) setProposalStats(s.proposalStats);
        setAttentionProposals(s.attentionProposals   ?? []);
        setUnproposedDemands(s.unproposedDemands     ?? []);
        setMissingCatSites(s.missingCatSites         ?? []);
        setMissingCatSuppliers(s.missingCatSuppliers ?? []);
        setTopSuppliers(s.topSuppliers               ?? []);
        setTopUsedSuppliersList(s.topUsedSuppliersList ?? []);
        setTopDemandSites(s.topDemandSites           ?? []);
        if (s.supplierHealth !== undefined) setSupplierHealth(s.supplierHealth);
        if (s.atRiskSites    !== undefined) setAtRiskSites(s.atRiskSites);
        setExpiringEngagements(s.expiringEngagements ?? []);
        setLoading(false);
    }

    // ── Cache bootstrap + worker lifecycle ──────────────────────────────────
    useEffect(() => {
        if (!user || !accessToken) return;

        const orgId    = getTenantOverride();
        const cacheKey = getCacheKey(user.email, orgId);
        const cached   = readCache(cacheKey);
        const isFirstLoad = !cached;

        // cancelled + pending timers — cleared if the user leaves the page
        let cancelled = false;
        const pendingTimers = [];

        if (cached) {
            applyDisplayState(cached.displayState);
            const age = Date.now() - cached.fetchedAt;
            const ttl = Number(localStorage.getItem('sl_dashboard_debug_ttl') || CACHE_TTL);
            if (age <= ttl) {
                setPhase('fresh');
                return; // data is fresh — no worker needed
            }
            setPhase('refreshing'); // stale: show data immediately + start background refresh
        } else {
            setPhase('firstLoad');
        }

        // Start Web Worker for background fetch — only runs while this component is mounted
        const worker = new Worker(
            new URL('./dashboardWorker.js', import.meta.url),
            { type: 'module' }
        );
        workerRef.current = worker;

        worker.onmessage = ({ data }) => {
            workerRef.current = null;
            // User may have navigated away between the fetch completing and this callback
            if (cancelled) return;

            if (data.type !== 'SUCCESS') {
                if (isFirstLoad) setLoading(false);
                setPhase('fresh');
                return;
            }

            const displayState = processResults(data.results);
            writeCache(cacheKey, displayState);

            if (isFirstLoad) {
                // First ever load — apply data and reveal dashboard
                applyDisplayState(displayState);
                setPhase('fresh');
            } else {
                // Stale refresh — dim → swap data → spring reveal
                setIsTransitioning(true);
                const t1 = setTimeout(() => {
                    if (cancelled) return;
                    applyDisplayState(displayState);
                    setIsTransitioning(false);
                    setDataRevealActive(true);  // triggers scan line + spring animation
                    setPhase('refreshed');
                    // Clear reveal animation after it completes
                    const t2 = setTimeout(() => {
                        if (cancelled) return;
                        setDataRevealActive(false);
                    }, 900);
                    pendingTimers.push(t2);
                    // Auto-dismiss the "updated" pill after 3 s
                    const t3 = setTimeout(() => {
                        if (cancelled) return;
                        setPhase('fresh');
                    }, 3000);
                    pendingTimers.push(t3);
                }, 200);
                pendingTimers.push(t1);
            }
        };

        worker.onerror = () => {
            workerRef.current = null;
            if (cancelled) return;
            if (isFirstLoad) setLoading(false);
            setPhase('fresh');
        };

        worker.postMessage({ token: accessToken, orgId, urls: buildDashboardUrls() });

        return () => {
            // User navigated away — stop everything immediately
            cancelled = true;
            pendingTimers.forEach(clearTimeout);
            worker.terminate();
            workerRef.current = null;
        };
    }, [user, accessToken]); // re-run if user or token changes

    const today = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });
    const showRefreshPill = phase === 'refreshing' || phase === 'refreshed';

    return (
        <Layout pagetitle="Dashboard" headerTitle="Dashboard">
            <style>{KEYFRAMES}</style>

            <div className="p-6 max-w-5xl space-y-6">

                {/* ── First-time loading banner / Hero ──────────────────── */}
                {phase === 'firstLoad' ? (
                    <FirstLoadBanner />
                ) : (
                    <div className="rounded-2xl overflow-hidden"
                         style={{
                             background: 'linear-gradient(135deg, #0f172a 0%, #1e1b4b 55%, #2e1065 100%)',
                             boxShadow: '0 20px 40px rgba(15,23,42,0.35)',
                             position: 'relative',
                         }}>

                        {/* Refresh status pill — top-right corner */}
                        {showRefreshPill && (
                            <div style={{ position: 'absolute', top: 14, right: 16, zIndex: 10 }}>
                                <HeroRefreshPill phase={phase} />
                            </div>
                        )}

                        {/* Shine sweep during dim-out; flash when new data arrives */}
                        {isTransitioning && (
                            <div style={{
                                position: 'absolute', inset: 0, zIndex: 5,
                                pointerEvents: 'none', overflow: 'hidden',
                            }}>
                                <div style={{
                                    position: 'absolute', top: 0, bottom: 0, width: '55%',
                                    background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.07), transparent)',
                                    animation: 'dashHeroShine 0.55s ease forwards',
                                }}/>
                            </div>
                        )}
                        {dataRevealActive && (
                            <div style={{
                                position: 'absolute', inset: 0, zIndex: 4,
                                pointerEvents: 'none',
                                background: 'rgba(255,255,255,0.055)',
                                animation: 'dashHeroFlash 0.55s ease forwards',
                            }}/>
                        )}

                        <div className="px-7 pt-7 pb-5">
                            <p className="text-xs font-medium mb-1"
                               style={{color: 'rgba(255,255,255,0.3)', fontFamily: "'JetBrains Mono', monospace", letterSpacing: '0.12em'}}>
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
                )}

                {/* ── Insight panels + leaderboards (cross-fade on refresh) ─ */}
                <div style={{
                    position: 'relative',
                    opacity: isTransitioning ? 0.28 : 1,
                    transform: isTransitioning ? 'scale(0.996) translateY(4px)' : undefined,
                    transition: isTransitioning ? 'opacity 0.2s ease, transform 0.2s ease' : undefined,
                    animation: dataRevealActive ? 'dashDataReveal 0.65s cubic-bezier(0.22,1,0.36,1) forwards' : undefined,
                }}>
                    {/* Scan line sweeps top-to-bottom as new data reveals */}
                    {dataRevealActive && (
                        <div style={{
                            position: 'absolute', left: 0, right: 0, height: 2, zIndex: 20,
                            background: 'linear-gradient(90deg, transparent 0%, rgba(129,140,248,0.85) 20%, rgba(192,132,252,0.95) 50%, rgba(129,140,248,0.85) 80%, transparent 100%)',
                            boxShadow: '0 0 18px rgba(129,140,248,0.9), 0 0 8px rgba(192,132,252,0.7)',
                            animation: 'dashScanLine 0.75s ease-in-out forwards',
                            pointerEvents: 'none',
                        }}/>
                    )}

                    {/* Insight panels */}
                    <div className="grid grid-cols-4 gap-4">

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

                        {/* Expiring proposals */}
                        <PanelCard title="Expiring soon" loading={loading} accentColor="#f97316" to="/proposals" linkLabel="All proposals →">
                            {(() => {
                                const expiringSoon = expiringEngagements.filter(e => {
                                    const ms = new Date(e.expiresAt) - Date.now();
                                    const hours = ms / 3_600_000;
                                    return hours < 12;
                                });
                                return expiringSoon.length === 0 ? (
                                    <div className="flex flex-col items-center justify-center py-4 gap-2">
                                        <div className="w-7 h-7 rounded-full bg-emerald-50 border border-emerald-100 flex items-center justify-center">
                                            <svg className="w-3.5 h-3.5 text-emerald-500" fill="none" viewBox="0 0 24 24" strokeWidth={2.5} stroke="currentColor">
                                                <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                                            </svg>
                                        </div>
                                        <p className="text-[11px] text-slate-400 text-center leading-relaxed">All clear — nothing<br/>expiring in 12 hours</p>
                                    </div>
                                ) : (
                                    <div className="flex flex-col">
                                        {expiringSoon.slice(0, 5).map(e => {
                                            const { label, level } = formatTimeRemaining(e.expiresAt);
                                            const badge = {
                                                critical: { color: '#dc2626', bg: '#fef2f2', border: '#fecaca', pulse: true  },
                                                warning:  { color: '#ea580c', bg: '#fff7ed', border: '#fed7aa', pulse: false },
                                                caution:  { color: '#ca8a04', bg: '#fefce8', border: '#fde68a', pulse: false },
                                                ok:       { color: '#4f46e5', bg: '#eef2ff', border: '#c7d2fe', pulse: false },
                                            }[level];
                                            return (
                                                <div key={e.id} className="flex items-center justify-between py-1.5 border-b border-slate-50 last:border-0 gap-2">
                                                    <Link
                                                        to={`/proposals/${e.proposalId}`}
                                                        className="text-xs text-slate-700 truncate hover:text-indigo-600 hover:underline min-w-0 transition-colors"
                                                        title={e.supplierName}
                                                    >
                                                        {e.supplierName}
                                                    </Link>
                                                    <span
                                                        className={`text-[10px] font-bold shrink-0 px-1.5 py-0.5 rounded border tabular-nums ${badge.pulse ? 'animate-pulse' : ''}`}
                                                        style={{
                                                            color: badge.color,
                                                            background: badge.bg,
                                                            border: `1px solid ${badge.border}`,
                                                            fontFamily: "'JetBrains Mono', monospace",
                                                        }}
                                                    >
                                                        {label}
                                                    </span>
                                                </div>
                                            );
                                        })}
                                    </div>
                                );
                            })()}
                        </PanelCard>

                    </div>

                    {/* ── Supplier pipeline health ───────────────────────── */}
                    <div className="mt-4">
                        <SupplierPipelineHealthPanel
                            healthData={supplierHealth}
                            atRiskData={atRiskSites}
                            loading={loading}
                        />
                    </div>

                    {/* ── Usage leaderboards ────────────────────────────── */}
                    <div className="grid grid-cols-2 gap-4 mt-4">

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

                </div>{/* end cross-fade wrapper */}

                {/* ── Quick nav ─────────────────────────────────────────── */}
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
