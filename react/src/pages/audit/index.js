import React, {useState, useEffect} from 'react'

import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import AuditCard, { AuditLine } from '@/components/AuditCard';
import Modal from '@/components/atoms/Modal';

export default function AuditIndexPage() {

    const [audits, setAudits] = useState()
    const [error, setError] = useState()

    useEffect( () => {
        const auditUrl = "/.rest/auditrecords"
        fetch(auditUrl)
            .then((resp)=>resp.json())
            .then((data)=> setAudits(data._embedded.auditrecords))
            .catch((error)=>setError(error))
    },[]);

    return (
        <Layout>
            <PageTitle title="Audit" />
            
            {audits ? 
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