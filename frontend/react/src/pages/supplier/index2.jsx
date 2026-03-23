import React, { useState, useEffect, useRef } from 'react'
import { Link, useSearchParams, useNavigate } from "react-router-dom";

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/PageTitle";
import { SupplierCardHorizontalRowLayout } from "@/components/SupplierCard";
import TextInput from "@/components/atoms/TextInput";
import SessionButton from "@/components/atoms/Button";
import { Toggle } from '@/components/atoms/Toggle';
import Loading from '@/components/Loading';
import Paging from '@/components/Paging';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';

const PAGE_SIZE = 20;

function SortHeader({ label, field, sortBy, sortDir, onSort, className = '' }) {
    const active = sortBy === field;
    return (
        <button
            onClick={() => onSort(field)}
            className={`flex items-center gap-1 text-xs font-semibold text-gray-500 uppercase tracking-wide hover:text-gray-800 transition-colors ${className}`}
        >
            {label}
            <span className={`text-xs ${active ? 'text-blue-600' : 'text-gray-300'}`}>
                {active && sortDir === 'desc' ? '↓' : '↑'}
            </span>
        </button>
    );
}

export default function SupplierListView() {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const page = parseInt(searchParams.get('page') ?? '1');  // 1-based

    const [suppliers, setSuppliers]             = useState([]);
    const [totalPages, setTotalPages]           = useState(0);
    const [totalElements, setTotalElements]     = useState(null);
    const [searchInput, setSearchInput]         = useState('');
    const [search, setSearch]                   = useState('');
    const [includeDisabled, setIncludeDisabled] = useState(false);
    const [sortBy, setSortBy]                   = useState('');
    const [sortDir, setSortDir]                 = useState('asc');
    const [isLoading, setIsLoading]             = useState(false);
    const [responsiveness, setResponsiveness]   = useState({});
    const [supplierUsageCount, setSupplierUsageCount] = useState({});

    // Debounce search input (300ms)
    useEffect(() => {
        const t = setTimeout(() => setSearch(searchInput), 300);
        return () => clearTimeout(t);
    }, [searchInput]);

    // Reset to page 1 when filters or sort change
    const isFirstRender = useRef(true);
    useEffect(() => {
        if (isFirstRender.current) { isFirstRender.current = false; return; }
        navigate('/supplier/list2?page=1');
    }, [search, includeDisabled, sortBy, sortDir]);

    // Fetch responsiveness data once
    useEffect(() => {
        fetchWithAuth("/.rest/stats/responsiveness/all")
            .then(res => res.ok ? res.json() : {})
            .then(data => setResponsiveness(data))
            .catch(() => {});
    }, []);

    // Fetch
    useEffect(() => {
        setIsLoading(true);
        const params = new URLSearchParams({ page: page - 1, size: PAGE_SIZE, search, includeDisabled });
        if (sortBy) { params.set('sortBy', sortBy); params.set('direction', sortDir); }

        fetchWithAuth(`/.rest/supplierSupport/list?${params}`)
            .then(r => r.ok ? r.json() : Promise.reject())
            .then(data => {
                setSuppliers(data.content ?? []);
                setTotalPages(data.totalPages ?? 0);
                setTotalElements(data.totalElements ?? 0);
                setIsLoading(false);

                const ids = (data.content ?? []).map(s => s.id).join(",");
                if (ids) {
                    fetchWithAuth("/.rest/paidlinksupport/getcountsforsuppliers?supplierIds=" + ids)
                        .then(r => r.ok ? r.json() : {})
                        .then(counts => setSupplierUsageCount(counts))
                        .catch(() => {});
                }
            })
            .catch(() => setIsLoading(false));
    }, [page, search, includeDisabled, sortBy, sortDir]);

    function handleSort(field) {
        if (sortBy === field) setSortDir(d => d === 'asc' ? 'desc' : 'asc');
        else { setSortBy(field); setSortDir('asc'); }
    }

    return (
        <Layout pagetitle='Supplier list'>
            {/* Title + actions */}
            <div className="flex items-center gap-4 px-4 pt-2 pb-1">
                <PageTitle id="supplier-list-id" title="Suppliers" count={suppliers}/>
                <div className="inline-flex items-center gap-3">
                    <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                        <Link to='/supplier/Add' rel='nofollow'>
                            <SessionButton label="New"/>
                        </Link>
                    </AuthorizedAccess>
                    <Link to='/supplier' className="text-sm text-blue-600 hover:underline">Card view</Link>
                </div>
                {totalElements !== null &&
                    <span className="ml-auto text-xs text-gray-400 shrink-0">
                        {totalElements} supplier{totalElements !== 1 ? 's' : ''}
                    </span>
                }
            </div>

            {/* Filters */}
            <div className="flex items-center gap-4 px-4 pb-3">
                <div className="w-64">
                    <TextInput
                        changeHandler={setSearchInput}
                        binding={searchInput}
                        label="Name / email / domain"
                        id="supplierListSearch"
                    />
                </div>
                <div className="flex flex-col gap-1 pb-1">
                    <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Show disabled</span>
                    <Toggle changeHandler={setIncludeDisabled} initialValue={includeDisabled} label=""/>
                </div>
            </div>

            <Paging page={page} pageCount={totalPages} total={totalElements} baseUrl="/supplier/list2"/>

            {/* Table */}
            <div className="mx-4 bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">

                {/* Header row */}
                <div className="flex items-center gap-4 px-4 py-2 bg-gray-50 border-b border-gray-200">
                    <div className="w-56 shrink-0 text-xs font-semibold text-gray-500 uppercase tracking-wide">Website</div>
                    <div className="flex-1 text-xs font-semibold text-gray-500 uppercase tracking-wide">Categories</div>
                    <div className="w-36 shrink-0 text-xs font-semibold text-gray-500 uppercase tracking-wide">Traffic / mo</div>
                    <div className="w-16 shrink-0 text-center">
                        <SortHeader label="DA" field="da" sortBy={sortBy} sortDir={sortDir} onSort={handleSort}/>
                    </div>
                    <div className="w-24 shrink-0">
                        <SortHeader label="Fee" field="weWriteFee" sortBy={sortBy} sortDir={sortDir} onSort={handleSort}/>
                    </div>
                    <div className="w-16 shrink-0 text-center text-xs font-semibold text-gray-500 uppercase tracking-wide">Usages</div>
                    <div className="w-28 shrink-0 text-xs font-semibold text-gray-500 uppercase tracking-wide">Responsiveness</div>
                    <div className="w-10 shrink-0"/>
                </div>

                {/* Rows */}
                {isLoading
                    ? <div className="py-12"><Loading/></div>
                    : suppliers.length === 0
                        ? <p className="text-sm text-gray-400 text-center py-12">No suppliers found.</p>
                        : suppliers.map((s, i) =>
                            <SupplierCardHorizontalRowLayout key={s.id ?? i} supplier={s} linkable={true} responsiveness={responsiveness[s.id]} usageCount={supplierUsageCount[s.id]}/>
                        )
                }

            </div>
        </Layout>
    );
}
