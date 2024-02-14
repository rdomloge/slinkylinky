'use client'

import React, {useState, useEffect} from 'react'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import DemandSiteSearchResult, { DemandSiteListItemLite } from '@/components/DemandSite';

export default function DemandSiteList() {

    const [demandsites, setDemandSites] = useState()
    const [missingCategories, setMissingCategories] = useState([])
    const [error, setError] = useState()

    useEffect(() => {
        const demandSitesUrl = "/.rest/demandsites?projection=fullDemandSite&sort=name,asc&size=100"
        fetch(demandSitesUrl)
            .then((res) => res.json())
            .then((data) => {
                setDemandSites(data._embedded.demandsites.filter(ds => ds.categories && ds.categories.filter(c => c.disabled == false).length > 0))
                setMissingCategories(data._embedded.demandsites.filter(ds => ! ds.categories || ds.categories.filter(c => c.disabled == false).length < 1))
        ***REMOVED***)
            .catch((err) => setError(err))
***REMOVED***, []);

    return (
        <Layout>
            <PageTitle title="Demand sites" count={demandsites ? demandsites.concat(missingCategories) : null}/>
            <p className="pl-2">{demandsites ? (missingCategories.length + " missing categories (top of page), " + demandsites.length+" categorised") : ""}</p>
            <div className="grid grid-cols-3">
                {missingCategories ?
                    missingCategories.map( (ds,index) => 
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index}/>
                    )
                : <Loading/> }
            </div>
            <div className="inline-flex items-center justify-center w-full">
                <hr className="w-4/5 h-px my-8 bg-gray-500 border-0 dark:bg-gray-700"/>
                <span className="absolute px-3 font-medium text-gray-900 -translate-x-2/5 colourOfBackground left-1/2 dark:text-white dark:bg-gray-900">
                    With categories
                </span>
            </div>
            <div className="grid grid-cols-3">
                {demandsites ?
                    demandsites.map( (ds,index) => 
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index}/>
                    )
                : <Loading error={error}/> }
            </div>
        </Layout>
    );
}