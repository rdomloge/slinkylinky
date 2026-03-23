import React, { useState, useEffect } from 'react';
import Layout from '@/components/layout/Layout';
import { useAuth } from '@/auth/AuthProvider';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { Link } from 'react-router-dom';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';

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

// ─── Sub-components ─────────────────────────────────────────────────────────

function StatCard({ label, value, sub, loading, to, colour = 'blue' }) {
    const colours = {
        blue:   'bg-blue-50 text-blue-600',
        green:  'bg-green-50 text-green-600',
        purple: 'bg-purple-50 text-purple-600',
    };
    const inner = (
        <div className="card p-5 flex flex-col gap-2 hover:shadow-md transition-shadow h-full">
            <span className={`text-xs font-semibold uppercase tracking-wide px-2 py-0.5 rounded-full w-fit ${colours[colour]}`}>
                {label}
            </span>
            {loading
                ? <div className="h-8 w-16 bg-gray-100 rounded animate-pulse mt-1"/>
                : <span className="text-3xl font-bold text-gray-900">{value ?? '—'}</span>
            }
            {sub && !loading && <span className="text-xs text-gray-400">{sub}</span>}
        </div>
    );
    return to ? <Link to={to} className="block">{inner}</Link> : inner;
}

function PanelCard({ title, loading, children, to, linkLabel }) {
    return (
        <div className="card p-5 flex flex-col gap-3">
            <div className="flex items-center justify-between">
                <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide">{title}</p>
                {to && <Link to={to} className="text-xs text-blue-500 hover:underline">{linkLabel ?? 'View all'}</Link>}
            </div>
            {loading
                ? <div className="space-y-2">{[1,2,3].map(i => <div key={i} className="h-4 bg-gray-100 rounded animate-pulse"/>)}</div>
                : children
            }
        </div>
    );
}

function NavCard({ to, label, description, icon }) {
    return (
        <Link to={to}>
            <div className="card p-4 flex items-start gap-3 hover:shadow-md transition-shadow h-full">
                <div className="shrink-0 w-9 h-9 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                    {icon}
                </div>
                <div>
                    <p className="text-sm font-semibold text-gray-800">{label}</p>
                    <p className="text-xs text-gray-400 mt-0.5">{description}</p>
                </div>
            </div>
        </Link>
    );
}

// ─── Nav section definitions ─────────────────────────────────────────────────

const navSections = [
    {
        to: '/demand', label: 'Demand', description: 'Manage and fulfil link demands',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 0 0-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 0 0-16.536-1.84M7.5 14.25 5.106 5.272M6 20.25a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Zm12.75 0a.75.75 0 1 1-1.5 0 .75.75 0 0 1 1.5 0Z"/></svg>,
    },
    {
        to: '/categories', label: 'Categories', description: 'Organise demand and supplier categories',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 0 0 3 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 0 0 5.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 0 0 9.568 3Z"/><path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6Z"/></svg>,
    },
    {
        to: '/supplier', label: 'Suppliers', description: 'Search and manage your supplier network',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z"/></svg>,
    },
    {
        to: '/proposals', label: 'Proposals', description: 'Track workflow from sent to live',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z"/></svg>,
    },
    {
        to: '/demandsites', label: 'Demand Sites', description: 'Manage client sites and their demand',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"/><path strokeLinecap="round" strokeLinejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z"/></svg>,
    },
    {
        to: '/audit', label: 'Audit', description: 'Review activity and trace changes',
        icon: <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={1.8} stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z"/></svg>,
    },
];

const ordersSection = {
    to: '/orders', label: 'Orders', description: 'Monitor orders end-to-end',
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
    const [loading, setLoading]                 = useState(true);

    useEffect(() => {
        if (!user) return;

        const thisMonth = buildDateRange(0);
        const sixMonths = buildDateRange(6);

        const safeJson = url => fetchWithAuth(url)
            .then(r => r.ok ? r.json() : Promise.reject())
            .catch(() => null);

        Promise.all([
            // Unsatisfied demand
            safeJson('/.rest/demands/search/findUnsatisfiedDemandOrderedByRequested?projection=fullDemand'),
            // Active supplier count
            safeJson('/.rest/suppliers/search/countByDisabledFalse'),
            // This month's proposals (for stats)
            safeJson(`/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${thisMonth.start}&endDate=${thisMonth.end}&projection=fullProposal`),
            // 6 months of proposals (for fastest supplier response times)
            safeJson(`/.rest/proposalsupport/getProposalsWithOriginalSuppliers?startDate=${sixMonths.start}&endDate=${sixMonths.end}&projection=fullProposal`),
            // Top suppliers by all-time link count
            safeJson('/.rest/paidlinksupport/topbysuppliers?limit=5'),
            // Demand sites missing categories
            safeJson('/.rest/demandsites/search/findByMissingCategories'),
            // Suppliers missing categories
            safeJson('/.rest/suppliers/search/findByCategoriesIsEmptyAndDisabledFalse?projection=fullSupplier'),
            // Top demand sites by demand count
            safeJson('/.rest/demandssitesupport/topbydemands?limit=5'),
        ]).then(([demands, suppliers, thisMonthProposals, sixMonthProposals, topSuppliersData, missingSites, missingCatSuppliersData, allSitesPage]) => {

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

            setLoading(false);
        }).catch(() => setLoading(false));
    }, [user]);

    const today = new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' });

    return (
        <Layout pagetitle="Dashboard">
            <div className="p-6 max-w-5xl space-y-8">

                {/* Greeting */}
                <div>
                    <h1 className="text-2xl font-bold text-gray-900">{greeting(user?.name)}</h1>
                    <p className="text-sm text-gray-400 mt-0.5">{today}</p>
                </div>

                {/* Stat cards */}
                <div className="grid grid-cols-3 gap-4">
                    <StatCard label="Active demands"        value={demandCount}          loading={loading} to="/demand"    colour="blue"/>
                    <StatCard label="Active suppliers"      value={activeSuppliers}      loading={loading} to="/supplier"  colour="green"/>
                    <StatCard
                        label="Proposals this month"
                        value={proposalStats?.total}
                        sub={proposalStats ? `${proposalStats.attention} needing attention · ${proposalStats.chasing} to chase · ${proposalStats.complete} complete` : null}
                        loading={loading}
                        to="/proposals"
                        colour="purple"
                    />
                </div>

                {/* Insight panels */}
                <div className="grid grid-cols-3 gap-4">

                    {/* Fastest suppliers */}
                    <PanelCard title="Fastest to respond" loading={loading} to="/supplier">
                        {topSuppliers.length === 0
                            ? <p className="text-xs text-gray-400">Not enough data yet.</p>
                            : topSuppliers.map((s, i) => (
                                <div key={s.domain} className="flex items-center justify-between py-1.5 border-b border-gray-50 last:border-0">
                                    <div className="flex items-center gap-2">
                                        <span className="w-5 h-5 rounded-full bg-blue-50 text-blue-600 text-xs font-bold flex items-center justify-center shrink-0">{i + 1}</span>
                                        <span className="text-sm text-gray-700 truncate">{s.domain}</span>
                                    </div>
                                    <span className="text-xs font-medium text-gray-500 shrink-0 ml-2">
                                        {s.avg < 1 ? '< 1 day' : `${Math.round(s.avg)}d`}
                                        <span className="text-gray-300 ml-1">({s.count})</span>
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                    {/* Missing categories (suppliers + demand sites) */}
                    <PanelCard title="Missing categories" loading={loading}>
                        {/* Demand sites */}
                        <div>
                            <p className="text-xs font-medium text-gray-500 mb-1.5">
                                Demand sites
                                <span className={`ml-1 px-1.5 py-0.5 rounded-full text-xs ${missingCatSites.length === 0 ? 'bg-green-100 text-green-700' : 'bg-amber-100 text-amber-700'}`}>
                                    {missingCatSites.length}
                                </span>
                            </p>
                            {missingCatSites.length === 0
                                ? <p className="text-xs text-gray-400">All sites have categories</p>
                                : missingCatSites.slice(0, 3).map(ds => (
                                    <div key={ds.id} className="flex items-center justify-between py-1 border-b border-gray-50 last:border-0">
                                        <div className="min-w-0">
                                            <p className="text-xs text-gray-700 truncate">{ds.name}</p>
                                            <p className="text-xs text-gray-400 truncate">{ds.domain}</p>
                                        </div>
                                        <Link to={`/demandsites/${ds.id}`} className="shrink-0 ml-2 text-xs text-blue-500 hover:underline">Edit</Link>
                                    </div>
                                ))
                            }
                        </div>
                        {/* Suppliers */}
                        <div className="mt-3 pt-3 border-t border-gray-100">
                            <p className="text-xs font-medium text-gray-500 mb-1.5">
                                Suppliers
                                <span className={`ml-1 px-1.5 py-0.5 rounded-full text-xs ${missingCatSuppliers.length === 0 ? 'bg-green-100 text-green-700' : 'bg-amber-100 text-amber-700'}`}>
                                    {missingCatSuppliers.length}
                                </span>
                            </p>
                            {missingCatSuppliers.length === 0
                                ? <p className="text-xs text-gray-400">All active suppliers have categories</p>
                                : missingCatSuppliers.slice(0, 3).map(s => (
                                    <div key={s.id} className="flex items-center justify-between py-1 border-b border-gray-50 last:border-0">
                                        <span className="text-xs text-gray-700 truncate">{s.domain || s.name}</span>
                                        <Link to={`/supplier/${s.id}`} className="shrink-0 ml-2 text-xs text-blue-500 hover:underline">Edit</Link>
                                    </div>
                                ))
                            }
                        </div>
                    </PanelCard>

                    {/* Action items */}
                    <PanelCard title="Needs attention" loading={loading}>
                        {/* Demands without a proposal */}
                        <div>
                            <p className="text-xs font-medium text-gray-500 mb-1.5">
                                Demand to fulfil
                                {demandCount !== null && <span className="ml-1 bg-blue-100 text-blue-700 px-1.5 py-0.5 rounded-full text-xs">{demandCount}</span>}
                            </p>
                            {unproposedDemands.length === 0
                                ? <p className="text-xs text-gray-400">None outstanding</p>
                                : unproposedDemands.map(d => (
                                    <div key={d.id} className="flex items-center justify-between py-1 border-b border-gray-50 last:border-0">
                                        <span className="text-xs text-gray-700 truncate">{d.name}</span>
                                        <Link to={`/supplier/search/${d.id}`} className="shrink-0 ml-2 text-xs text-blue-500 hover:underline">Fulfil</Link>
                                    </div>
                                ))
                            }
                        </div>

                        {/* Proposals needing our attention */}
                        <div className="mt-3 pt-3 border-t border-gray-100">
                            <p className="text-xs font-medium text-gray-500 mb-1.5">
                                Proposals needing attention
                                {proposalStats && <span className="ml-1 bg-purple-100 text-purple-700 px-1.5 py-0.5 rounded-full text-xs">{proposalStats.attention}</span>}
                            </p>
                            {attentionProposals.length === 0
                                ? <p className="text-xs text-gray-400">None this month</p>
                                : attentionProposals.map(p => (
                                    <div key={p.id} className="flex items-center justify-between py-1 border-b border-gray-50 last:border-0">
                                        <span className="text-xs text-gray-700 truncate">{p.paidLinks[0].supplier.domain || p.paidLinks[0].supplier.name}</span>
                                        <Link to={`/proposals/${p.id}`} className="shrink-0 ml-2 text-xs text-blue-500 hover:underline">View</Link>
                                    </div>
                                ))
                            }
                        </div>
                    </PanelCard>

                </div>

                {/* Usage panels */}
                <div className="grid grid-cols-2 gap-4">

                    {/* Top 5 most used suppliers */}
                    <PanelCard title="Most used suppliers" loading={loading} to="/supplier">
                        {topUsedSuppliersList.length === 0
                            ? <p className="text-xs text-gray-400">Not enough data yet.</p>
                            : topUsedSuppliersList.map((s, i) => (
                                <div key={s.domain} className="flex items-center justify-between py-1.5 border-b border-gray-50 last:border-0">
                                    <div className="flex items-center gap-2 min-w-0">
                                        <span className="w-5 h-5 rounded-full bg-green-50 text-green-600 text-xs font-bold flex items-center justify-center shrink-0">{i + 1}</span>
                                        <span className="text-sm text-gray-700 truncate">{s.domain}</span>
                                    </div>
                                    <span className="text-xs font-medium text-gray-500 shrink-0 ml-2">
                                        {s.linkCount} {s.linkCount === 1 ? 'link' : 'links'}
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                    {/* Top 5 most used demand sites */}
                    <PanelCard title="Most active demand sites" loading={loading} to="/demandsites">
                        {topDemandSites.length === 0
                            ? <p className="text-xs text-gray-400">No data yet.</p>
                            : topDemandSites.map((ds, i) => (
                                <div key={ds.id} className="flex items-center justify-between py-1.5 border-b border-gray-50 last:border-0">
                                    <div className="flex items-center gap-2 min-w-0">
                                        <span className="w-5 h-5 rounded-full bg-purple-50 text-purple-600 text-xs font-bold flex items-center justify-center shrink-0">{i + 1}</span>
                                        <div className="min-w-0">
                                            <p className="text-sm text-gray-700 truncate">{ds.name}</p>
                                            <p className="text-xs text-gray-400 truncate">{ds.domain}</p>
                                        </div>
                                    </div>
                                    <span className="text-xs font-medium text-gray-500 shrink-0 ml-2">
                                        {ds.demandCount ?? 0} {(ds.demandCount ?? 0) === 1 ? 'demand' : 'demands'}
                                    </span>
                                </div>
                            ))
                        }
                    </PanelCard>

                </div>

                {/* Quick nav */}
                <div>
                    <h2 className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">Navigate</h2>
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
