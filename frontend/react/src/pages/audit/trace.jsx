import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'react-router-dom'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import TimelineEntry from '@/components/atoms/TimelineEntry';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function EntityAuditTrail() {
    const [searchParams] = useSearchParams()
    const [trail, setTrail] = useState()

    useEffect(
        () => {
            const entityType = searchParams.get('entityType')
            const entityId = searchParams.get('entityId')
            if (!entityType || !entityId) return
            const trailUrl = "/.rest/auditrecords/search/findByEntityTypeAndEntityIdOrderByEventTimeAsc"
                + "?entityType="+entityType
                + "&entityId="+entityId

            fetchWithAuth(trailUrl).then(resp=>resp.json()).then(data=>setTrail(data))
        }, [searchParams]
    );

    return (
        <Layout pagetitle='Audit trace'>
            <PageTitle title="Audit trail" id="audit-trace-title-id"/>
            <ol className="relative border-s border-gray-600 dark:border-gray-700">
                {trail 
                ?
                    trail.map( (ar,index) => {return <TimelineEntry date={ar.eventTime} what={ar.what} detail={ar.detail} previousDetail={index>0?trail[index-1].detail:""} who={ar.who} key={index}/>} )
                :
                    <Loading/>
                }
            </ol>
        </Layout>
    );
}