'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemandcard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'
import AddOrEditDemand from '@/components/AddOrEditDemand'

export default function LinkDemand() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = '/.rest/linkdemands/'+ router.query.linkdemandid+"?projection=fullLinkDemand";
                fetch(demandUrl)
                    .then(res => res.json())
                        .then(json => {
                            json.id = router.query.linkdemandid;
                            setDemand(json);
                    ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.linkdemandid]
    )

    return (
        <Layout>
            <PageTitle title="Edit Demand"/>
            {demand ? 
                <AddOrEditDemand demand={demand}/>
            : <>Loading...</>}
        </Layout>
    );
}