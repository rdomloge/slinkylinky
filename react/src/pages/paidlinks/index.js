import React, {useState, useEffect} from 'react'
import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";

export default function PaidLinks() {

    const paidLinksUrl = "/.rest/paidlinks"
    const [paidLinks, setPaidlinks] = useState()

    useEffect( () => {
        fetch(paidLinksUrl).then(res => res.json()).then(pls => setPaidlinks(pls))
***REMOVED***)

    if(paidLinks) {
        return(
            <Layout>
                <PageTitle title="Paid links"/>
                
            </Layout>
        );
***REMOVED***
    else return <>Loading...</>
}