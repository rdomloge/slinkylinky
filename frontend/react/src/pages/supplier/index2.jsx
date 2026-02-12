import React, {useState, useEffect} from 'react'
import { Link } from "react-router-dom";

import Icon from '@/pages/supplier/arrow-bend-up.svg'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import SupplierCard, { SupplierCardHorizontalRowLayout } from "@/components/suppliercard";
import TextInput from "@/components/atoms/TextInput";
import CategoryFilter from "@/components/CategorySelector";
import SessionButton from "@/components/atoms/Button";
import NumberInput from '@/components/atoms/NumberInput';
import Loading from '@/components/Loading';
import { fetchWithAuth } from '@/utils/fetchWithAuth';
import { AuthorizedAccess } from '@/components/authorizedAccess';

export default function ListBloggers() {
    const [suppliers, setSuppliers] = useState()
    
    const [supplierCount, setSupplierCount] = useState()
    const [activeSupplierCount, setActiveSupplierCount] = useState()
    const [supplierUsageCount, setSupplierUsageCount] = useState();
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
    }, []);

    useEffect(
        () => {
            
                setSuppliers(null)
                setIsLoading(true)
                const supplierUsageCountUrl = "/.rest/paidlinksupport/getcountsforsuppliers?supplierIds="
                const suppliersUrl = "/.rest/suppliers/search"+
                                        "/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrDomainContainsIgnoreCaseOrCategories_NameInOrDaGreaterThan"+
                                        "?projection=fullSupplier"+
                                        filterOrBlankString("email", "war", 3)+
                                        filterOrBlankString("name", "war", 3)+
                                        filterOrBlankString("domain", "war", 3)+
                                        filterOrMaxNum("da", 20, 40, 100)
                
                fetchWithAuth(suppliersUrl)
                    .then( (res) => res.json())
                    .then( (data) => {
                        setSuppliers(data)
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
            
        }, []
    );

    function filterOrBlankString(key, value, min) {
        if(value && value.length >= min) return "&"+key+"="+value;
        return ""
    }

    function filterOrMaxNum(key, value, min, max) {
        if(value && value >= min) return "&"+key+"="+value;
        return "&"+key+"="+max;
    }

    
    return (
        <Layout pagetitle='Supplier list'>
            <PageTitle id="supplier-list-id" title="Suppliers" count={suppliers ? suppliers : null}/> 
            <div className="content-center pt-2 pl-4 inline-block">
                <AuthorizedAccess allowedRoles={['tenant_admin', 'global_admin']}>
                    <Link to='/supplier/Add' rel='nofollow'>
                        <SessionButton label="New"/>
                    </Link>
                </AuthorizedAccess>
            </div>
            
            {suppliers && suppliers.length > 0 ?
                <div className="grid grid-cols-1">
                    <div className="list-card-horizontal card relative">
                        <div className='grid grid-cols-12 gap-4'>
                            <div className='col-span-2 font-bold'>Website</div>
                            <div className='col-span-2 font-bold'>Niche</div>
                            <div className='col-span-3 font-bold'>Traffic</div>
                            <div className='col-span-1 font-bold'>DA</div>
                            <div className='col-span-1 font-bold'>Spam</div>
                            <div className='col-span-1 font-bold'>Fee</div>
                        </div>
                    </div>
                    {suppliers.map( (s, index) => 
                        <div key={index}>
                            <SupplierCardHorizontalRowLayout supplier={s} linkable={true}/>
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