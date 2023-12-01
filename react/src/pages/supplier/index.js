'use client'

import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import React, {useState, useEffect} from 'react'
import SupplierCard from "@/components/suppliercard";

export default function ListBloggers() {
    const [bloggers, setBloggers] = useState()
    const bloggersUrl = "http://localhost:8080/bloggers?projection=fullBlogger";

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    useEffect(
        () => {
            fetch(bloggersUrl)
                .then( (res) => res.json())
                .then( (data) => setBloggers(data));
    ***REMOVED***, []
    );

    if(bloggers) {
        return (
            <Layout>
                <PageTitle title="Suppliers"/>
                <ol>
                    {bloggers._embedded.bloggers.map( (s) => <li key={parseId(s)}><SupplierCard supplier={s}/></li>)}
                </ol>
            </Layout>
        );
***REMOVED***
    else {
        return <div>Loading...</div>
***REMOVED***
}