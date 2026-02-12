import React, {useState, useEffect} from 'react'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import { AuditLine } from '@/components/AuditCard';
import Paging from '@/components/Paging';
import { useSearchParams } from 'react-router-dom';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function AuditIndexPage() {

    const [searchParams] = useSearchParams()
    const [audits, setAudits] = useState()
    const [error, setError] = useState()
    const [page, setPage] = useState(0)
    const [total, setTotal] = useState(0)
    const [pageCount, setPageCount] = useState(0)

    useEffect( () => {
        const page = searchParams.get('page') ? parseInt(searchParams.get('page')) : 1
        setPage(page)
        const auditUrl = "/.rest/auditrecords?size=10&page="+(page-1)
        fetchWithAuth(auditUrl)
            .then((resp)=>resp.json())
            .then((data)=> {
                setAudits(data._embedded.auditrecords)
                setTotal(data.page.totalElements)
                setPageCount(data.page.totalPages)
            })
            .catch((error)=>setError("Can't fetch audit records. Is the Audit service running? "+error.statusMessage))
    },[searchParams]);

    return (
        <Layout pagetitle='Audit trail'>
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