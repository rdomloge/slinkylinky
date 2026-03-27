import React, { useState, useEffect, useRef, useCallback } from 'react'
import { Link } from "react-router-dom";

import Layout from "@/components/layout/Layout";
import { SupplierCardHorizontalRowLayout } from "@/components/SupplierCard";
import TextInput from "@/components/atoms/TextInput";
import SessionButton from "@/components/atoms/Button";
import { Toggle } from '@/components/atoms/Toggle';
import Loading from '@/components/Loading';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';

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
    const [sortBy, setSortBy]                   = useState('');
    const [sortDir, setSortDir]                 = useState('asc');
    const [isLoading, setIsLoading]             = useState(false);
    const [responsiveness, setResponsiveness]   = useState({});
    const [supplierUsageCount, setSupplierUsageCount] = useState({});

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
        const params = new URLSearchParams({ page, size: PAGE_SIZE, search, includeDisabled });
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
    }, [search, includeDisabled, sortBy, sortDir]);

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
        <Layout pagetitle='Supplier list'>

            {/* Page header */}
            <div className="flex items-center justify-between px-6 pt-6 pb-4 gap-3 flex-wrap">
                <h1 id="supplier-list-id" className="pageTitle">
                    Suppliers
                    {suppliers.length > 0 && <span className="text-slate-400 font-normal text-2xl ml-2">({suppliers.length})</span>}
                </h1>
                <div className="flex items-center gap-3">
                    <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                        <Link to='/supplier/Add' rel='nofollow'>
                            <SessionButton label="New"/>
                        </Link>
                    </AuthorizedAccess>
                    <Link to='/supplier/cards' className="text-sm text-slate-500 hover:text-slate-800 transition-colors">Card view</Link>
                    {totalElements !== null &&
                        <span className="text-xs text-slate-500 bg-slate-100 px-2.5 py-1 rounded-full font-medium">
                            {totalElements} supplier{totalElements !== 1 ? 's' : ''}
                        </span>
                    }
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
                    <div className="w-28 shrink-0 text-xs font-semibold text-slate-500 uppercase tracking-wider">Responsiveness</div>
                    <div className="w-10 shrink-0"/>
                </div>

                {/* Rows */}
                {suppliers.length === 0 && !isLoading
                    ? <p className="text-sm text-slate-400 text-center py-12">No suppliers found.</p>
                    : suppliers.map((s, i) =>
                        <SupplierCardHorizontalRowLayout key={s.id ?? i} supplier={s} linkable={true} responsiveness={responsiveness[s.id]} usageCount={supplierUsageCount[s.id]}/>
                    )
                }

                {/* Sentinel + spinner */}
                {isLoading && <div className="py-6"><Loading/></div>}
                <div ref={sentinelRef}/>

            </div>
        </Layout>
    );
}
