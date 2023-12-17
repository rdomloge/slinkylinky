'use client'

import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import CategoryListItem from "@/components/CategoryListItem";

export default function ListCategories() {
    const [categories, setCategories] = useState()
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
                .then( (data) => setCategories(data));
        }, []
    );

    if(categories) {
        return (
            <Layout>
                <PageTitle title="Categories"/>
                <ol>
                    {categories._embedded.categories.map( (c) => <li key={parseId(c)}><CategoryListItem category={c}/></li>)}
                </ol>
            </Layout>
        );
    }
    else {
        return <div>Loading...</div>
    }
}