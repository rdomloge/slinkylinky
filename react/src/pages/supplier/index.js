'use client'

import React, {useState, useEffect} from 'react'
import Link from "next/link";

import Image from 'next/image'
import Icon from '@/pages/supplier/upthere.png'

import Layout from "@/components/Layout";
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

    useEffect(() => {
        const countUrl = "/.rest/suppliers/search/findCount"
        fetch(countUrl)
            .then( (res) => res.json())
            .then( (data) => setSupplierCount(data));
***REMOVED***);

    useEffect(
        () => {
            const suppliersUrl = "/.rest/suppliers/search"+
                                    "/findByEmailContainsIgnoreCaseOrNameContainsIgnoreCaseOrCategories_NameIn"+
                                    "?projection=fullSupplier"+
                                    filterOrBlank("email")+
                                    filterOrBlank("name")+
                                    categoriesToCsvArray();
              
            fetch(suppliersUrl)
                .then( (res) => res.json())
                .then( (data) => setSuppliers(data));
            
    ***REMOVED***, [filter, categoriesFilter]
    );

    function filterOrBlank(key) {
        if(filter) return "&"+key+"="+filter;
        return ""
***REMOVED***

    function categoriesToCsvArray() {
        if(categoriesFilter) {
            const cats = "&categories="+ categoriesFilter.map(c => c.label)
            return cats
    ***REMOVED***
        else return ""
***REMOVED***

    function categoriesFilterChangeHandler(categories) {
        setCategoriesFilter(categories)
***REMOVED***

    
    return (
        <Layout>
            <PageTitle title="Suppliers" count={suppliers ? suppliers.length : ""}/> 
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
                            <SupplierCard supplier={s} editable={true} linkable={true}/>
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
        ***REMOVED***
            
        </Layout>
    );
    
}