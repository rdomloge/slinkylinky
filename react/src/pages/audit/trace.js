import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'

import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import Loading from '@/components/Loading';
import TimelineEntry from '@/components/atoms/TimelineEntry';

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

                fetch(trailUrl).then(resp=>resp.json()).then(data=>setTrail(data))
        ***REMOVED***
    ***REMOVED***, [router.isReady]
    );

    return (
        <Layout>
            <PageTitle title="Audit trail"/>
            <ol className="relative border-s border-gray-600 dark:border-gray-700">
                {trail 
                ?
                    trail.map( (ar,index) => {return <TimelineEntry date={ar.eventTime} what={ar.what} detail={ar.detail} previousDetail={index>0?trail[index-1].detail:""} who={ar.who} key={index}/>} )
                :
                    <Loading/>
            ***REMOVED***
            </ol>
        </Layout>
    );
}