'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemandcard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'

export default function LinkDemand() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = 'http://localhost:8080/linkdemands/'+ router.query.linkdemandid+"?projection=fullLinkDemand";
                fetch(demandUrl)
                    .then(res => res.json())
                        .then(json => setDemand(json));
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.linkdemandid]
    )

    return (
        <Layout>
            <PageTitle title="Demand"/>
            {demand ? 
                <LinkDemandCard linkdemand={demand}/>
            : <>Loading...</>}
        </Layout>
    );
}