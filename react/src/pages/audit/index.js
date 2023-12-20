import React, {useState, useEffect} from 'react'

import Layout from "@/components/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import AuditCard, { AuditLine } from '@/components/AuditCard';
import Modal from '@/components/atoms/Modal';

export default function AuditIndexPage() {

    const [audits, setAudits] = useState()
    const [showModal, setShowModal] = useState()

    useEffect( () => {
        const auditUrl = "/.rest/auditrecords"
        fetch(auditUrl)
            .then((resp)=>resp.json())
            .then((data)=>
                setAudits(data._embedded.auditrecords))
***REMOVED***,[]);

    return (
        <Layout>
            <PageTitle title="Audit" />
            <div className="grid grid-cols-4 gap-2">
            {audits ? 
                audits.map( (a,index) => {
                    return <AuditLine auditrecord={a} key={index}/>
            ***REMOVED***)
            :
                <Loading />
        ***REMOVED***
            </div>
            {showModal ?
                <Modal width="w-full" title="Audit trail"  dismissHandler={()=>setShowModal(false)}>
                    
                </Modal>
            : 
            null}
        </Layout>
    );
}