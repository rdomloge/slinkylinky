'use client'

import React, {useState, useEffect} from 'react'
import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import DemandSiteSearchResult, { DemandSiteListItemLite } from '@/components/DemandSite';

export default function DemandSiteList() {

    const [demandsites, setDemandSites] = useState()

    useEffect(() => {
        const demandSitesUrl = "/.rest/demandsites?projection=fullDemandSite&sort=name,asc&size=100"
        fetch(demandSitesUrl)
            .then((res) => res.json())
            .then((data) => setDemandSites(data._embedded.demandsites))
***REMOVED***, []);

    return (
        <Layout>
            <PageTitle title="Demand sites" count={demandsites ? demandsites.length : ""}/>
            <div className="grid grid-cols-3">
                {demandsites ?
                    demandsites.map( (ds,index) => 
                        <DemandSiteListItemLite demandSite={ds} key={index}/>
                    )
                : <Loading/> }
            </div>
        </Layout>
    );
}