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
import NumberInput from '@/components/atoms/NumberInput';
import Loading from '@/components/Loading';

export default function ListBloggers() {
    const [suppliers, setSuppliers] = useState()
    const [filter, setFilter] = useState()
    const [categoriesFilter, setCategoriesFilter] = useState()
    const [supplierCount, setSupplierCount] = useState()
    const [activeSupplierCount, setActiveSupplierCount] = useState()
    const [supplierUsageCount, setSupplierUsageCount] = useState();
    const [daFilter, setDaFilter] = useState(0)
    const [isLoading, setIsLoading] = useState(false)

    useEffect(() => {
        const countUrl = "/.rest/suppliers/search/count"
        const activeCountUrl = "/.rest/suppliers/search/countByDisabledFalse"
        fetch(countUrl)
            .then( (res) => res.json())
            .then( (data) => setSupplierCount(data));

        fetch(activeCountUrl)
            .then( (res) => res.json())
            .then( (data) => setActiveSupplierCount(data));
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
                
                fetch(suppliersUrl)
                    .then( (res) => res.json())
                    .then( (data) => {
                        setSuppliers(data)
                        setIsLoading(false)
                        var usageUrl = supplierUsageCountUrl;
                        data.forEach((s,index) => usageUrl += s.id + (index < data.length-1 ? "," : ""));
                        fetch(usageUrl)
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
        }, [filter, categoriesFilter, daFilter]
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
        <Layout>
            <PageTitle title="Suppliers" count={suppliers ? suppliers : null}/> 
            <span className='pb-4'>{supplierCount} &#47;&#47; total suppliers ({activeSupplierCount} active)</span>
            <div className="content-center pt-2">
                <Link href='/supplier/Add'>
                    <SessionButton label="New"/>
                </Link>
            </div>
            <div className="w-1/4 pr-8 inline-block">
                <TextInput changeHandler={(value) =>setFilter(value)} label="Name / email / domain filter"/>
            </div>
            <div className="w-1/3 pr-8 inline-block">
                <CategoryFilter changeHandler={categoriesFilterChangeHandler} label="Category filter"/>
            </div>
            <div className="w-1/6 pr-8 inline-block">
                <NumberInput changeHandler={(value) =>setDaFilter(value)} binding={daFilter} 
                    label="DA filter (min. 40)" step={10}/>
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
            isLoading ?
                    <Loading/>
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