'use client'

import React, {useState, useEffect} from 'react'
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import DemandSiteSearchResult, { DemandSiteListItemLite } from '@/components/DemandSite';
import { useSession } from 'next-auth/react';

export default function DemandSiteList() {

    const [demandsites, setDemandSites] = useState()
    const [missingCategories, setMissingCategories] = useState([])
    const [error, setError] = useState()
    const { data: session } = useSession();

    function deleteDemandSite(ds) {
        fetch('/.rest/demandssitesupport/delete?demandSiteId='+ds.id, {
            method: 'DELETE',
            headers: {'user': session.user.name}
        })
        .then(response => {
            if(response.ok) {
                const withCategoriesIndex = demandsites.indexOf(ds);
                const missingCategoriesIndex = missingCategories.indexOf(ds);
                if (missingCategoriesIndex > -1) {
                    const newDemandsites = [...missingCategories];
                    newDemandsites.splice(missingCategoriesIndex, 1);
                    setMissingCategories(newDemandsites);
                }
                else if (withCategoriesIndex > -1) {
                    const newDemandsites = [...demandsites];
                    newDemandsites.splice(withCategoriesIndex, 1);
                    setDemandSites(newDemandsites);
                }
                else {
                    console.error("Can't delete demand site, not found.")
                }
            }
        })
    }

    useEffect(() => {
        const demandSitesUrl = "/.rest/demandsites?projection=fullDemandSite&sort=name,asc&size=100"
        fetch(demandSitesUrl)
            .then((res) => {
                if (!res.ok) {
                    throw new Error("Can't fetch demand sites.")
                }
                return res.json()
            })
            .then((data) => {
                setDemandSites(data._embedded.demandsites.filter(ds => ds.categories && ds.categories.filter(c => c.disabled == false).length > 0))
                setMissingCategories(data._embedded.demandsites.filter(ds => ! ds.categories || ds.categories.filter(c => c.disabled == false).length < 1))
            })
            .catch((err) => setError(err.message))
    }, []);

    return (
        <Layout>
            <PageTitle id="demandsite-list-id" title="Demand sites" count={demandsites ? demandsites.concat(missingCategories) : null}/>
            <p className="pl-2">{demandsites ? (missingCategories.length + " missing categories (top of page), " + demandsites.length+" categorised") : ""}</p>
            <div className="grid grid-cols-3">
                {missingCategories ?
                    missingCategories.map( (ds,index) => 
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
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
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)}/>
                    )
                : <Loading error={error}/> }
            </div>
        </Layout>
    );
}