'use client'

import AddOrEditDemandSite from "@/components/AddOrEditDemandSite";
import React, {useState, useEffect} from 'react';
import { useRouter } from 'next/router'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from "@/components/Loading";

export default function DemandSite() {
    const router = useRouter()
    const [demandSite, setDemandSite] = useState(null)
    const [error, setError] = useState(null)

    useEffect( 
        () => {
            if(router.isReady) {
                const demandSiteUrl = "/.rest/demandsites/"+router.query.demandsiteid + "?projection=fullDemandSite"
                
                fetch(demandSiteUrl)
                    .then(res => res.json())
                    .then(data => setDemandSite(data))
                    .catch(err => setError(err));
            }
        }, [router.isReady, router.query.demandsiteid]);

    return (
        <Layout pagetitle="Edit demand site">
            <PageTitle title="Edit demand site" id="demandsite-detail-title-id"/>
            {demandSite ? 
                <AddOrEditDemandSite demandSite={demandSite}/>
            : 
                <Loading error={error}/> 
            }
        </Layout>
    );
}