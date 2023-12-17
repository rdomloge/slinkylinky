'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/Layout'
import AddOrEditDemand from '@/components/AddOrEditDemand'

export default function Demand() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = '/.rest/demands/'+ router.query.demandid+"?projection=fullDemand";
                fetch(demandUrl)
                    .then(res => res.json())
                        .then(json => {
                            json.id = router.query.demandid;
                            setDemand(json);
                    ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.demandid]
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