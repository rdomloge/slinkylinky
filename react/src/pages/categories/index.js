'use client'

import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import CategoryListItem from "@/components/CategoryListItem";

export default function ListCategories() {
    const [categories, setCategories] = useState()
    const catUrl = "http://localhost:8080/categories";

    useEffect(
        () => {
            fetch(catUrl)
                .then( (res) => res.json())
                .then( (data) => setCategories(data));
    ***REMOVED***, []
    );

    if(categories) {
        return (
            <Layout>
                <PageTitle title="Categories"/>
                <ol>
                    {categories._embedded.categories.map( (c) => <li><CategoryListItem category={c}/></li>)}
                </ol>
            </Layout>
        );
***REMOVED***
    else {
        return <div>Loading...</div>
***REMOVED***
}