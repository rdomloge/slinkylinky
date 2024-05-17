import React, {useState, useEffect} from 'react'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import { AuditLine } from '@/components/AuditCard';
import Paging from '@/components/Paging';
import { useRouter } from 'next/router';

export default function AuditIndexPage() {

    const router = useRouter()
    const [audits, setAudits] = useState()
    const [error, setError] = useState()
    const [page, setPage] = useState(0)
    const [total, setTotal] = useState(0)
    const [pageCount, setPageCount] = useState(0)

    useEffect( () => {
        if(router.isReady) {
            const page = router.query.page ? parseInt(router.query.page) : 1
            setPage(page)
            const auditUrl = "/.rest/auditrecords?size=10&page="+(page-1)
            fetch(auditUrl)
                .then((resp)=>resp.json())
                .then((data)=> {
                    setAudits(data._embedded.auditrecords)
                    setTotal(data.page.totalElements)
                    setPageCount(data.page.totalPages)
                })
                .catch((error)=>setError("Can't fetch audit records. Is the Audit service running? "+error.statusMessage))
        }
    },[router.isReady, router.query.page]);

    return (
        <Layout>
            <PageTitle title="Audit" count={audits} id="audit-list-title-id"/>
            <Paging page={page} pageCount={pageCount} total={total} baseUrl={"/audit"}/>
            { !error && audits ? 
                <div className="grid grid-cols-4 gap-2">
                {audits.map( (a,index) => {
                    return <AuditLine auditrecord={a} key={index}/>
                })}
                </div>
            :
                <Loading error={error}/>
            }
        </Layout>
    );
}