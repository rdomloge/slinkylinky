'use client'

import React, {useState, useEffect} from 'react'
import Link from "next/link";

import Image from 'next/image'
import Icon from '@/pages/supplier/arrow-bend-up.svg'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import SupplierCard from "@/components/suppliercard";
import TextInput from "@/components/atoms/TextInput";
import CategoryFilter from "@/components/CategorySelector";
import SessionButton from "@/components/atoms/Button";

export default function ListBloggers() {
    const [suppliers, setSuppliers] = useState()
    const [filter, setFilter] = useState()
    const [categoriesFilter, setCategoriesFilter] = useState()
    const [supplierCount, setSupplierCount] = useState()
    const [supplierUsageCount, setSupplierUsageCount] = useState();

    useEffect(() => {
        const countUrl = "/.rest/suppliers/search/findCount"
        fetch(countUrl)
            .then( (res) => res.json())
            .then( (data) => setSupplierCount(data));
    }, []);

    useEffect(
        () => {
            if((filter && filter.length > 2) || categoriesFilter && categoriesFilter.length > 0) {
                const supplierUsageCountUrl = "/.rest/paidlinksupport/getcountsforsuppliers?supplierIds="
                const suppliersUrl = "/.rest/suppliers/search"+
                                        "/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrCategories_NameIn"+
                                        "?projection=fullSupplier"+
                                        filterOrBlank("email")+
                                        filterOrBlank("name")+
                                        categoriesToCsvArray();
                
                fetch(suppliersUrl)
                    .then( (res) => res.json())
                    .then( (data) => {
                        setSuppliers(data)
                        var usageUrl = supplierUsageCountUrl;
                        data.forEach((s,index) => usageUrl += s.id + (index < data.length-1 ? "," : ""));
                        fetch(usageUrl)
                            .then(resCount => resCount.json())
                            .then(counts => {
                                setSupplierUsageCount(counts)
                            })
                    });
            }
            else {
                setSuppliers(null)
            }
        }, [filter, categoriesFilter]
    );

    function filterOrBlank(key) {
        if(filter && filter.length > 2) return "&"+key+"="+filter;
        return ""
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

    function LinkCountChild({supplier}) {
        const [linkCount, setLinkCount] = useState()
        useEffect(() => {
            const linkCountUrl = "/.rest/paidlinks/search/countBySupplierId?supplierId="+supplier.id
            fetch(linkCountUrl).then(resp => resp.json()).then(data => setLinkCount(data));
        });
        return <span className='inline-block'>{linkCount} links</span>
    }

    
    return (
        <Layout>
            <PageTitle title="Suppliers" count={suppliers ? suppliers : null}/> 
            <span className='pb-4'>{supplierCount} &#47;&#47; total suppliers</span>
            <div className="content-center pt-2">
                <Link href='/supplier/Add'>
                    <SessionButton label="New"/>
                </Link>
            </div>
            <div className="w-1/4 pr-8 inline-block">
                <TextInput changeHandler={(value) =>setFilter(value)} label="Name or email filter"/>
            </div>
            <div className="w-1/3 pr-8 inline-block">
                <CategoryFilter changeHandler={categoriesFilterChangeHandler} label="Category filter"/>
            </div>
            {suppliers && suppliers.length > 0 ?
                <div className="grid grid-cols-3">
                    {suppliers.map( (s, index) => 
                        <div key={index}>
                            <SupplierCard supplier={s} editable={true} usages={supplierUsageCount} linkable={true}/>
                        </div>
                    )}
                </div> 
            :
            <div className="flex flex-col h-full">
                <div className="flex justify-center items-center flex-grow">
                    <Image src={Icon} width={227} height={222} alt="Up arrow" className="p-1 inline-block"/>
                    <p className="text-slate-500 text-8xl">Set a filter</p>
                </div>
            </div>
            }
            
        </Layout>
    );
    
}