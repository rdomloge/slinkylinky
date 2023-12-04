'use client'

import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import SupplierCard from "@/components/suppliercard";
import TextInput from "@/components/TextInput";
import CategoryFilter from "@/components/CategorySelector";
import Link from "next/link";

export default function ListBloggers() {
    const [suppliers, setSuppliers] = useState()
    const [filter, setFilter] = useState()
    const [categoriesFilter, setCategoriesFilter] = useState()

    useEffect(
        () => {
            const suppliersUrl = "http://localhost:8080/suppliers/search"+
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
            <div className="w-1/4 pr-8 inline-block">
                <TextInput changeHandler={(value) =>setFilter(value)} label="Name or email filter"/>
            </div>
            <div className="w-1/3 pr-8 inline-block">
                <CategoryFilter changeHandler={categoriesFilterChangeHandler} label="Category filter"/>
            </div>
            {suppliers ?
                <div className="grid grid-cols-3">
                    {suppliers.map( (s, index) => 
                        <div key={index}>
                            <Link href={"/supplier/"+s.id}>
                                <SupplierCard supplier={s}/>
                            </Link>
                        </div>
                    )}
                </div> 
            :
                <p>Set a filter</p>
        ***REMOVED***
            
        </Layout>
    );
    
}