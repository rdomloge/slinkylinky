import React, {useState, useEffect} from 'react'
import { Link } from "react-router-dom";

import Icon from '@/assets/arrow-bend-up.svg'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/PageTitle";
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
        <Layout pagetitle='Supplier list'>
            <PageTitle id="supplier-list-id" title="Suppliers" count={suppliers ? suppliers : null}/> 
            <div className="inline-flex items-center gap-3 pt-2 pl-4">
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Link to='/supplier/Add' rel='nofollow'>
                        <SessionButton label="New"/>
                    </Link>
                </AuthorizedAccess>
                <Link to='/supplier/list2' className="text-sm text-blue-600 hover:underline">List view</Link>
            </div>
            <span className='pb-4 block'>{supplierCount} &#47;&#47; total suppliers ({activeSupplierCount} active)</span>
            <div className="flex items-end gap-4 px-4 py-3">
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
                    <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Show disabled</span>
                    <Toggle changeHandler={setShowDisabled} initialValue={showDisabled} label=""/>
                </div>
            </div>
            {suppliers && suppliers.length > 0 ?
                <div className="grid grid-cols-3">
                    {suppliers.map( (s, index) => 
                        <div key={index}>
                            <SupplierCard supplier={s} editable={true} usages={supplierUsageCount} responsiveness={responsiveness} linkable={true} id={"supplier-card-"+index}/>
                        </div>
                    )}
                </div> 
            :
            isLoading ?
                    <Loading/>
                :
                    <div className="flex flex-col h-full">
                        <div className="flex justify-center items-center flex-grow">
                            <img src={Icon} width={227} height={222} alt="Up arrow" className="p-1 inline-block"/>
                            <p className="text-slate-500 text-8xl">Set a filter</p>
                        </div>
                    </div>
            }
            
        </Layout>
    );
    
}