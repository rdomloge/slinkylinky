import React, {useState, useEffect} from 'react'
import { Link } from "react-router-dom";

import Icon from '@/assets/arrow-bend-up.svg'

import Layout from "@/components/layout/Layout";
import SupplierCard from "@/components/SupplierCard";
import TextInput from "@/components/atoms/TextInput";
import CategoryFilter from "@/components/CategorySelector";
import SessionButton from "@/components/atoms/Button";
import NumberInput from '@/components/atoms/NumberInput';
import { Toggle } from '@/components/atoms/Toggle';
import Loading from '@/components/Loading';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { AuthorizedAccess } from '@/components/AuthorizedAccess';

export default function ListBloggers() {
    const [suppliers, setSuppliers] = useState()
    const [filter, setFilter] = useState()
    const [categoriesFilter, setCategoriesFilter] = useState()
    const [supplierCount, setSupplierCount] = useState()
    const [activeSupplierCount, setActiveSupplierCount] = useState()
    const [supplierUsageCount, setSupplierUsageCount] = useState();
    const [responsiveness, setResponsiveness] = useState();
    const [daFilter, setDaFilter] = useState(0)
    const [showDisabled, setShowDisabled] = useState(false)
    const [isLoading, setIsLoading] = useState(false)

    useEffect(() => {
        const countUrl = "/.rest/suppliers/search/count"
        const activeCountUrl = "/.rest/suppliers/search/countByDisabledFalse"
        fetchWithAuth(countUrl)
            .then( (res) => res.json())
            .then( (data) => setSupplierCount(data));

        fetchWithAuth(activeCountUrl)
            .then( (res) => res.json())
            .then( (data) => setActiveSupplierCount(data));

        fetchWithAuth("/.rest/stats/responsiveness/all")
            .then(res => res.ok ? res.json() : {})
            .then(data => setResponsiveness(data))
            .catch(() => {});
    }, []);

    useEffect(
        () => {
            if((filter && filter.length > 2) || categoriesFilter && categoriesFilter.length > 0 || daFilter && daFilter >= 40) {
                setSuppliers(null)
                setIsLoading(true)
                const supplierUsageCountUrl = "/.rest/paidlinksupport/getcountsforsuppliers?supplierIds="
                const suppliersUrl = "/.rest/suppliers/search"+
                                        "/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrDomainContainsIgnoreCaseOrCategories_NameInOrDaGreaterThan"+
                                        "?projection=fullSupplier"+
                                        filterOrBlankString("email", filter, 3)+
                                        filterOrBlankString("name", filter, 3)+
                                        filterOrBlankString("domain", filter, 3)+
                                        filterOrMaxNum("da", daFilter, 40, 100)+
                                        categoriesToCsvArray();
                
                fetchWithAuth(suppliersUrl)
                    .then( (res) => res.json())
                    .then( (data) => {
                        setSuppliers(showDisabled ? data : data.filter(s => !s.disabled))
                        setIsLoading(false)
                        var usageUrl = supplierUsageCountUrl;
                        data.forEach((s,index) => usageUrl += s.id + (index < data.length-1 ? "," : ""));
                        fetchWithAuth(usageUrl)
                            .then(resCount => resCount.json())
                            .then(counts => {
                                setSupplierUsageCount(counts)
                            })
                    })
                    .catch( (err) => {
                        console.error(err)
                        setIsLoading(false)
                    });
            }
            else {
                setSuppliers(null)
            }
        }, [filter, categoriesFilter, daFilter, showDisabled]
    );

    function filterOrBlankString(key, value, min) {
        if(value && value.length >= min) return "&"+key+"="+value;
        return ""
    }

    function filterOrMaxNum(key, value, min, max) {
        if(value && value >= min) return "&"+key+"="+value;
        return "&"+key+"="+max;
    }

    function categoriesToCsvArray() {
        if(categoriesFilter) {
            const cats = "&categories="+ categoriesFilter.map(c => c.label)
            return cats
        }
        else return ""
    }

    function categoriesFilterChangeHandler(categories) {
        setCategoriesFilter(categories)
    }

    
    return (
        <Layout pagetitle='Supplier list'
            headerTitle={<>Suppliers {suppliers && <span className="font-normal text-slate-400">({suppliers.length})</span>}</>}
            headerActions={<AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}><Link to='/supplier/Add' rel='nofollow'><SessionButton label="New"/></Link></AuthorizedAccess>}
        >

            {/* View switcher */}
            <div className="flex items-center gap-3 px-6 pb-3">
                <div className="inline-flex rounded-lg border border-slate-200 bg-white p-0.5 shadow-sm">
                    <Link to='/supplier' className="flex items-center gap-1.5 px-3 py-1.5 rounded-md text-slate-500 hover:text-slate-700 hover:bg-slate-50 text-sm font-medium transition-colors">
                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                        </svg>
                        List
                        <span className="text-[9px] font-bold bg-indigo-100 text-indigo-700 px-1.5 py-0.5 rounded-full leading-none">New</span>
                    </Link>
                    <span className="flex items-center gap-1.5 px-3 py-1.5 rounded-md bg-indigo-600 text-white text-sm font-medium shadow-sm">
                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z"/>
                        </svg>
                        Cards
                    </span>
                </div>
                <span className="text-xs text-slate-400">Try the new list view</span>
            </div>

            {/* Filters */}
            <div className="flex items-end gap-4 px-6 py-4">
                <div className="w-1/4">
                    <TextInput changeHandler={(value) => setFilter(value)} binding={filter} label="Name / email / domain" id={"nameEmailDomainFilter"}/>
                </div>
                <div className="w-1/3">
                    <CategoryFilter changeHandler={categoriesFilterChangeHandler} label="Category filter"/>
                </div>
                <div className="w-1/6">
                    <NumberInput changeHandler={(value) => setDaFilter(value)} binding={daFilter}
                        label="DA filter (min. 40)" step={10}/>
                </div>
                <div className="flex flex-col gap-1 pb-1">
                    <span className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Show disabled</span>
                    <Toggle changeHandler={setShowDisabled} initialValue={showDisabled} label=""/>
                </div>
            </div>

            {/* Results */}
            {suppliers && suppliers.length > 0 ?
                <div className="grid grid-cols-3 gap-4 px-6 pb-6">
                    {suppliers.map((s, index) =>
                        <SupplierCard key={index} supplier={s} editable={true} usages={supplierUsageCount} responsiveness={responsiveness} linkable={true} id={"supplier-card-"+index}/>
                    )}
                </div>
            : isLoading ?
                <Loading/>
            :
                <div className="flex flex-col items-center justify-center gap-4 py-24 text-center">
                    <img src={Icon} width={80} height={80} alt="Up arrow" className="opacity-20"/>
                    <p className="text-slate-400 text-lg font-medium">Set a filter to find suppliers</p>
                </div>
            }
        </Layout>
    );
    
}