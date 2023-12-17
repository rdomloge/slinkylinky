'use client'

import AddOrEditDemandSite from "@/components/AddOrEditDemandSite";
import React, {useState, useEffect} from 'react';
import { useRouter } from 'next/router'
import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from "@/components/Loading";

export default function DemandSite() {
    const router = useRouter()
    const [demandSite, setDemandSite] = useState(null)

    useEffect( 
        () => {
            if(router.isReady) {
                const demandSiteUrl = "/.rest/demandsites/"+router.query.demandsiteid + "?projection=fullDemandSite"
                
                fetch(demandSiteUrl).then(res => res.json()).then(data => setDemandSite(data))
            }
        }, [router.isReady, router.query.demandsiteid]);

    return (
        <Layout>
            <PageTitle title="Edit demand site"/>
            {demandSite ? 
                <AddOrEditDemandSite demandSite={demandSite}/>
            : <Loading/>}
        </Layout>
    );
}