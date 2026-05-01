import React, { useState, useEffect, useRef, useCallback } from 'react'
import { Link } from "react-router-dom";

import Layout from "@/components/layout/Layout";
import { SupplierCardHorizontalRowLayout } from "@/components/SupplierCard";
import TextInput from "@/components/atoms/TextInput";
import SessionButton from "@/components/atoms/Button";
import { Toggle } from '@/components/atoms/Toggle';
import Loading from '@/components/Loading';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { AuthorizedAccess, useIsAdmin } from '@/components/AuthorizedAccess';

const PAGE_SIZE = 20;

function SortHeader({ label, field, sortBy, sortDir, onSort, className = '' }) {
    const active = sortBy === field;
    return (
        <button
            onClick={() => onSort(field)}
            className={`flex items-center gap-1 text-xs font-semibold text-slate-500 uppercase tracking-wide hover:text-slate-800 transition-colors ${className}`}
        >
            {label}
            <span className={`text-xs ${active ? 'text-indigo-600' : 'text-slate-300'}`}>
                {active && sortDir === 'desc' ? '↓' : '↑'}
            </span>
        </button>
    );
}

export default function SupplierListView() {
    const [suppliers, setSuppliers]             = useState([]);
    const [totalElements, setTotalElements]     = useState(null);
    const [searchInput, setSearchInput]         = useState('');
    const [search, setSearch]                   = useState('');
    const [includeDisabled, setIncludeDisabled] = useState(false);
    const [filterHighSpam, setFilterHighSpam]   = useState(true);
    const [sortBy, setSortBy]                   = useState('');
    const [sortDir, setSortDir]                 = useState('asc');
    const [isLoading, setIsLoading]             = useState(false);
    const [responsiveness, setResponsiveness]   = useState({});
    const [supplierUsageCount, setSupplierUsageCount] = useState({});
    const isAdmin = useIsAdmin();

    const nextPage   = useRef(0);
    const hasMore    = useRef(true);
    const sentinelRef = useRef(null);

    // Debounce search input (300ms)
    useEffect(() => {
        const t = setTimeout(() => setSearch(searchInput), 300);
        return () => clearTimeout(t);
    }, [searchInput]);

    // Fetch responsiveness data once
    useEffect(() => {
        fetchWithAuth("/.rest/stats/responsiveness/all")
            .then(res => res.ok ? res.json() : {})
            .then(data => setResponsiveness(data))
            .catch(() => {});
    }, []);

    const fetchPage = useCallback((page, append) => {
        setIsLoading(true);
        const params = new URLSearchParams({ page, size: PAGE_SIZE, search, includeDisabled, filterHighSpam, maxSpamScore: 6 });
        if (sortBy) { params.set('sortBy', sortBy); params.set('direction', sortDir); }

        fetchWithAuth(`/.rest/supplierSupport/list?${params}`)
            .then(r => r.ok ? r.json() : Promise.reject())
            .then(data => {
                const incoming = data.content ?? [];
                setSuppliers(prev => append ? [...prev, ...incoming] : incoming);
                setTotalElements(data.totalElements ?? 0);
                hasMore.current = page + 1 < (data.totalPages ?? 0);
                nextPage.current = page + 1;
                setIsLoading(false);

                const ids = incoming.map(s => s.id).join(",");
                if (ids) {
                    fetchWithAuth("/.rest/paidlinksupport/getcountsforsuppliers?supplierIds=" + ids)
                        .then(r => r.ok ? r.json() : {})
                        .then(counts => setSupplierUsageCount(prev => ({ ...prev, ...counts })))
                        .catch(() => {});
                }
            })
            .catch(() => setIsLoading(false));
    }, [search, includeDisabled, sortBy, sortDir, filterHighSpam]);

    // Reset and load page 0 when filters / sort change
    useEffect(() => {
        nextPage.current = 0;
        hasMore.current = true;
        setSuppliers([]);
        setSupplierUsageCount({});
        fetchPage(0, false);
    }, [fetchPage]);

    // IntersectionObserver — load next page when sentinel enters viewport
    useEffect(() => {
        const el = sentinelRef.current;
        if (!el) return;
        const observer = new IntersectionObserver(entries => {
            if (entries[0].isIntersecting && hasMore.current && !isLoading) {
                fetchPage(nextPage.current, true);
            }
        }, { rootMargin: '200px' });
        observer.observe(el);
        return () => observer.disconnect();
    }, [fetchPage, isLoading]);

    function handleSort(field) {
        if (sortBy === field) setSortDir(d => d === 'asc' ? 'desc' : 'asc');
        else { setSortBy(field); setSortDir('asc'); }
    }

    return (
        <Layout pagetitle='Supplier list'
            headerTitle={<>Suppliers {totalElements !== null && <span className="font-normal text-slate-400">({totalElements})</span>}</>}
            headerActions={<AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}><Link to='/supplier/Add' rel='nofollow'><SessionButton label="New"/></Link></AuthorizedAccess>}
        >


            {/* View switcher */}
            <div className="flex items-center gap-3 px-6 pb-3">
                <div className="inline-flex rounded-lg border border-slate-200 bg-white p-0.5 shadow-sm">
                    <span className="flex items-center gap-1.5 px-3 py-1.5 rounded-md bg-indigo-600 text-white text-sm font-medium shadow-sm">
                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                        </svg>
                        List
                    </span>
                    <Link to='/supplier/cards' className="flex items-center gap-1.5 px-3 py-1.5 rounded-md text-slate-500 hover:text-slate-700 hover:bg-slate-50 text-sm font-medium transition-colors">
                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z"/>
                        </svg>
                        Cards
                    </Link>
                </div>
            </div>

            {/* Filters */}
            <div className="flex items-center gap-6 px-6 pb-4">
                <div className="w-64">
                    <TextInput
                        changeHandler={setSearchInput}
                        binding={searchInput}
                        label="Name / email / domain"
                        id="supplierListSearch"
                    />
                </div>
                <div className="flex flex-col gap-1 pb-1">
                    <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Show disabled</span>
                    <Toggle changeHandler={setIncludeDisabled} initialValue={includeDisabled} label=""/>
                </div>
                <div className="flex flex-col gap-1 pb-1">
                    <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Hide high spam</span>
                    <Toggle changeHandler={setFilterHighSpam} initialValue={filterHighSpam} label=""/>
                </div>
            </div>

            {/* Table */}
            <div className="mx-6 bg-white border border-slate-200 rounded-xl overflow-hidden shadow-sm">

                {/* Header row */}
                <div className="flex items-center gap-4 px-4 py-3 bg-slate-50 border-b border-slate-200">
                    <div className="w-56 shrink-0 text-xs font-semibold text-slate-500 uppercase tracking-wider">Website</div>
                    <div className="flex-1 text-xs font-semibold text-slate-500 uppercase tracking-wider">Categories</div>
                    <div className="w-36 shrink-0 text-xs font-semibold text-slate-500 uppercase tracking-wider">Traffic / mo</div>
                    <div className="w-16 shrink-0 text-center">
                        <SortHeader label="DA" field="da" sortBy={sortBy} sortDir={sortDir} onSort={handleSort}/>
                    </div>
                    <div className="w-24 shrink-0">
                        <SortHeader label="Fee" field="weWriteFee" sortBy={sortBy} sortDir={sortDir} onSort={handleSort}/>
                    </div>
                    <div className="w-16 shrink-0 text-center text-xs font-semibold text-slate-500 uppercase tracking-wider">Usages</div>
                    <div className="w-40 shrink-0 text-xs font-semibold text-slate-500 uppercase tracking-wider">Responsiveness</div>
                    {isAdmin && (
                        <div className="flex items-center gap-2 shrink-0">
                            <span className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Actions</span>
                        </div>
                    )}
                </div>

                {/* Rows */}
                {suppliers.length === 0 && !isLoading
                    ? <p className="text-sm text-slate-400 text-center py-12">No suppliers found.</p>
                    : suppliers.map((s, i) =>
                        <SupplierCardHorizontalRowLayout key={s.id ?? i} supplier={s} linkable={true} responsiveness={responsiveness[s.id]} usageCount={supplierUsageCount[s.id]} showActions={isAdmin}/>
                    )
                }

                {/* Sentinel + spinner */}
                {isLoading && <div className="py-6"><Loading/></div>}
                <div ref={sentinelRef}/>

            </div>
        </Layout>
    );
}
