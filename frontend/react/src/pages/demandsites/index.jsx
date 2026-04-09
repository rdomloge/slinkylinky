import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'react-router-dom';
import Layout from "@/components/layout/Layout";
import Loading from '@/components/Loading';
import { DemandSiteListItemLite } from '@/components/DemandSite';
import Paging from '@/components/Paging';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function DemandSiteList() {

    const [searchParams] = useSearchParams()
    const [demandsites, setDemandSites] = useState()
    const [missingCategories, setMissingCategories] = useState([])
    const [error, setError] = useState()
    const [page, setPage] = useState(0)
    const [total, setTotal] = useState(0)
    const [pageCount, setPageCount] = useState(0)

    function deleteDemandSite(ds) {
        fetchWithAuth('/.rest/demandssitesupport/delete?demandSiteId='+ds.id, {
            method: 'DELETE',
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
        const missingCategoriesUrl = "/.rest/demandssitesupport/missingCategories";

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
        // Fetch the DSs with categories for the main list (paged)
        const page = searchParams.get('page') ? parseInt(searchParams.get('page')) : 1
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
    }, [searchParams]);

    return (
        <Layout pagetitle='Demand site list'
            headerTitle={<>Demand sites {demandsites && <span className="font-normal text-slate-400">({total})</span>}</>}
            headerActions={demandsites && (
                <div className="flex items-center gap-3 text-sm">
                    {missingCategories.length > 0 &&
                        <span className="inline-flex items-center gap-1.5 bg-amber-50 text-amber-700 border border-amber-200 px-3 py-1 rounded-full font-medium">
                            {missingCategories.length} missing categories
                        </span>
                    }
                    <span className="text-slate-400">{demandsites.length} categorised</span>
                </div>
            )}
        >

            {/* Missing categories section */}
            {missingCategories && missingCategories.length > 0 &&
                <>
                    <div className="px-6 mb-3">
                        <span className="text-xs font-semibold text-amber-600 uppercase tracking-wider">Missing categories</span>
                    </div>
                    <div className="grid grid-cols-3 gap-4 px-6 mb-6">
                        {missingCategories.map((ds, index) => (
                            <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-missing-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
                        ))}
                    </div>
                </>
            }
            {!missingCategories && <Loading/>}

            {/* Divider */}
            {missingCategories && missingCategories.length > 0 &&
                <div className="flex items-center gap-4 px-6 mb-4">
                    <div className="flex-1 h-px bg-slate-200"/>
                    <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider">With categories</span>
                    <div className="flex-1 h-px bg-slate-200"/>
                </div>
            }

            <Paging baseUrl="/demandsites" total={total} pageCount={pageCount} page={page} />

            <div className="grid grid-cols-3 gap-4 px-6 pb-6">
                {demandsites ?
                    demandsites.map( (ds,index) => (
                        <DemandSiteListItemLite demandSite={ds} key={index} id={"demandsite-"+index} deleteHandler={()=>deleteDemandSite(ds)} />
                    ))
                : <Loading/> }
            </div>
        </Layout>
    );
}