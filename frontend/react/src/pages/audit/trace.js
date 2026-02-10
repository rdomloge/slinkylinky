import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import TimelineEntry from '@/components/atoms/TimelineEntry';
import { fetchWithAuth } from '@/utils/fetchWithAuth';

export default function EntityAuditTrail() {
    const router = useRouter()
    const [trail, setTrail] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const entityType = router.query.entityType
                const entityId = router.query.entityId
                const trailUrl = "/.rest/auditrecords/search/findByEntityTypeAndEntityIdOrderByEventTimeAsc"
                    + "?entityType="+entityType
                    + "&entityId="+entityId

                fetchWithAuth(trailUrl).then(resp=>resp.json()).then(data=>setTrail(data))
            }
        }, [router.isReady]
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