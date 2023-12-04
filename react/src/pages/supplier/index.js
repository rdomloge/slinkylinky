'use client'

import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import SupplierCard from "@/components/suppliercard";
import TextFilter from "@/components/TextFilter";
import DemandStats from "@/components/DemandStats";
import CategoryFilter from "@/components/CategorySelector";

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
            
            // if(filter && (filter.length >= 3 || categoriesFilter)) {
                fetch(suppliersUrl)
                    .then( (res) => res.json())
                    .then( (data) => setSuppliers(data));
            // }
            // else {
            //     setSuppliers([])
            // }
        }, [filter, categoriesFilter]
    );

    function filterOrBlank(key) {
        if(filter) return "&"+key+"="+filter;
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

    
    return (
        <Layout>
            <PageTitle title="Suppliers" count={suppliers ? suppliers.length : ""}/>
            <DemandStats/>
            <TextFilter changeHandler={(value) =>setFilter(value)} label="Name or email filter"/>
            <div className="w-1/2">
                <CategoryFilter changeHandler={categoriesFilterChangeHandler} label="Category filter"/>
            </div>
            {suppliers ?
                <div className="grid grid-cols-3">
                    {suppliers.map( (s, index) => <div key={index}><SupplierCard supplier={s}/></div>)}
                </div> 
            :
                <p>Set a filter</p>
            }
            
        </Layout>
    );
    
}