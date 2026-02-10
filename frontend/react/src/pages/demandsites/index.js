import React, {useState, useEffect} from 'react'
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/router';
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import { DemandSiteListItemLite } from '@/components/DemandSite';
import Paging from '@/components/Paging';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function DemandSiteList() {

    const router = useRouter()
    const [demandsites, setDemandSites] = useState()
    const [missingCategories, setMissingCategories] = useState([])
    const [error, setError] = useState()
    const { data: session } = useSession();
    const [page, setPage] = useState(0)
    const [total, setTotal] = useState(0)
    const [pageCount, setPageCount] = useState(0)

    function deleteDemandSite(ds) {
        fetchWithAuth('/.rest/demandssitesupport/delete?demandSiteId='+ds.id, {
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

    // this fetches the DSs without categories for the top of the page, so only needs to be done once
    useEffect(() => {
        const missingCategoriesUrl = "/.rest/demandsites/search/findByMissingCategories";

        fetchWithAuth(missingCategoriesUrl)
            .then((res) => {
                if (!res.ok) {
                    throw new Error("Can't fetch demand sites with missing categories.")
                }
                return res.json()
            })
            .then((data) => {
                setMissingCategories(data)
            })
            .catch((err) => setError(err.message))
            
    }, [])

    // this fetches the DSs with categories for the main list (paged) so needs to re-run every time the page query changes
    useEffect(() => {

        if(router.isReady) {
            // Fetch the DSs with categories for the main list (paged)
            const page = router.query.page ? parseInt(router.query.page) : 1
            setPage(page)
            const demandSitesUrl = "/.rest/demandsites?projection=fullDemandSite&sort=name,asc&size=12&page="+(page-1)
            fetchWithAuth(demandSitesUrl)
                .then((res) => {
                    if (!res.ok) {
                        throw new Error("Can't fetch demand sites.")
                    }
                    return res.json()
                })
                .then((data) => {
                    setDemandSites(data._embedded.demandsites)
                    setTotal(data.page.totalElements)
                    setPageCount(data.page.totalPages)
                })
                .catch((err) => setError(err.message))
        }
    }, [router.isReady, router.query.page]);

    return (
        <Layout pagetitle='Demand site list'>
            <PageTitle id="demandsite-list-id" title="Demand sites" count={demandsites}/>
            <p className="pl-2">{demandsites ? (missingCategories.length + " missing categories (top of page), " + demandsites.length+" categorised") : ""}</p>
            
            <div className="grid grid-cols-3">
            {missingCategories ?
                missingCategories.map( (ds,index) => (
                    <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
                ))
            : <Loading/> }
        </div>

            <div className="inline-flex items-center justify-center w-full">
                <hr className="w-4/5 h-px my-8 bg-gray-500 border-0 dark:bg-gray-700"/>
                <span className="absolute px-3 font-medium text-gray-900 -translate-x-2/5 colourOfBackground left-1/2 dark:text-white dark:bg-gray-900">
                    With categories
                </span>
            </div>
            
            <Paging baseUrl="/demandsites" total={total} pageCount={pageCount} page={page} />

            <div className="grid grid-cols-3">
                {demandsites ?
                    demandsites.map( (ds,index) => (
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
                    ))
                : <Loading/> }
            </div>
        </Layout>
    );
}