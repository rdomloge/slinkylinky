'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import AddOrEditDemand from '@/components/AddOrEditDemand'
import Loading from '@/components/Loading'
import { fetchWithAuth } from '@/utils/fetchWithAuth'

export default function Demand() {
    const router = useRouter()
    const [demand, setDemand] = useState(null)
    const [error, setError] = useState(null)

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = '/.rest/demands/'+ router.query.demandid+"?projection=fullDemand";
                fetchWithAuth(demandUrl)
                    .then(res => res.json())
                        .then(json => {
                            json.id = router.query.demandid;
                            setDemand(json);
                        })
                    .catch(err => setError("Could not load Demand: "+err.statusMessage));
            }
        }, [router.isReady, router.query.demandid]
    )

    return (
        <Layout pagetitle='Edit demand'>
            <PageTitle id="demand-edit-id" title="Edit Demand"/>
            {demand ? 
                <AddOrEditDemand demand={demand}/>
            : 
                <Loading error={error}/> 
            }
        </Layout>
    );
}