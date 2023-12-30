'use client'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import CategoryListItem from "@/components/CategoryListItem";
import Loading from "@/components/Loading";

export default function ListCategories() {
    const [categories, setCategories] = useState()
    const [error, setError] = useState()

    const catUrl = "/.rest/categories";

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    useEffect(
        () => {
            fetch(catUrl)
                .then( (res) => res.json())
                .then( (data) => setCategories(data._embedded.categories))
                .catch( (error) => setError(error));
        }, []
    );

    
    return (
        <Layout>
            <PageTitle title="Categories" count={categories}/>
            {categories ?
                <ol>
                    {categories.map( (c) => <li key={parseId(c)}><CategoryListItem category={c}/></li>)}
                </ol>
            : 
                <Loading error={error}/>
            }
        </Layout>
    );
    
}