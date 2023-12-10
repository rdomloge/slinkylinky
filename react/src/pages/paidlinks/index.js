import React, {useState, useEffect} from 'react'
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";

export default function PaidLinks() {

    const paidLinksUrl = "/paidlinks"
    const [paidLinks, setPaidlinks] = useState()

    useEffect( () => {
        fetch(paidLinksUrl).then(res => res.json()).then(pls => setPaidlinks(pls))
    })

    if(paidLinks) {
        return(
            <Layout>
                <PageTitle title="Paid links"/>
                
            </Layout>
        );
    }
    else return <>Loading...</>
}